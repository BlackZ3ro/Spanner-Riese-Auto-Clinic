using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Spanner.Web.Auth;
using Spanner.Web.Models;
using Spanner.Web.Services;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

// Shape of add_booking_part's return row (supabase/migrations/0004_...sql).
// QuantityOnHand is nullable: the SQL function only finds a row to report a
// count from if p_stock_item_id still exists - currently always true here
// (the caller already confirmed the item exists just above), but nothing
// stops that from changing later, and a null deserializing into a non-
// nullable int would throw instead of degrading to the fallback message.
public record AddBookingPartResult(
    [property: JsonPropertyName("ok")] bool Ok,
    [property: JsonPropertyName("quantity_on_hand")] int? QuantityOnHand);

public class DetailsModel(Supabase.Client supabase, IConfiguration config) : PageModel
{
    // Admin-only gating (Finalize, Delete) checks this, server-side, on every
    // POST that needs it - never just hide the button. See Auth/AdminAccess.cs
    // for why this is a config allowlist and not a real roles table.
    public bool IsAdmin => config.IsAdmin(User.Identity?.Name);

    // "Send on WhatsApp": click-to-chat link with the reference code (or the
    // current status) typed in - see Services/CustomerWhatsApp.cs. PublicSiteUrl
    // is only set once the site is online, so the message can link to /Track.
    public string? WhatsAppUrl => Booking is { ReferenceCode.Length: > 0 } b
        ? CustomerWhatsApp.Link(b, config["PublicSiteUrl"])
        : null;
    public bool WhatsAppNumberKnown => CustomerWhatsApp.ToWhatsAppNumber(Booking?.CustomerPhone) is not null;

    public Booking? Booking { get; private set; }
    public List<Job> Jobs { get; private set; } = new();
    public string? LoadError { get; private set; }

    // Phases staff can choose; "finalized" is only ever set by Finalize & close
    // (same rule as mobile's updatePhase and the update_booking_phase function).
    public static readonly IReadOnlyList<(string Key, string Label)> SelectablePhases =
    [
        ("booked_in", "Book-in & Inspection"),
        ("labor_in_progress", "Labor in progress"),
        ("reassembly", "Reassembly"),
        ("ready_for_pickup", "Finished - ready for pickup"),
    ];

    [BindProperty]
    public string? NewPhase { get; set; }
    public string? JobsError { get; private set; }

    public List<BookingPart> PartsUsed { get; private set; } = new();
    public Dictionary<Guid, StockItem> StockItemsById { get; private set; } = new();
    public List<SelectListItem> StockItemOptions { get; private set; } = new();
    public string? PartsError { get; private set; }

    // FR-06: parts aren't scoped to individual jobs in this schema (booking_parts
    // has no job_id), so this is a booking-wide total rather than a per-job one -
    // sum of every part used on the booking, plus labour for every job that has
    // both hours and rate recorded (regardless of completion status). See
    // web/CLAUDE.md for why this diverges from the build plan's per-job total.
    public decimal PartsTotal => PartsUsed.Sum(p => p.UnitPrice * p.Quantity);
    public decimal LabourTotal => Jobs.Where(j => j.LabourHours is not null && j.LabourRate is not null)
        .Sum(j => j.LabourHours!.Value * j.LabourRate!.Value);
    public decimal GrandTotal => PartsTotal + LabourTotal;

    [BindProperty]
    [Required(ErrorMessage = "Enter a job type.")]
    public string NewJobType { get; set; } = string.Empty;

    [BindProperty]
    [Required(ErrorMessage = "Select a part.")]
    public Guid? NewPartStockItemId { get; set; }

    [BindProperty]
    [Required(ErrorMessage = "Enter a quantity.")]
    [Range(1, int.MaxValue, ErrorMessage = "Enter a quantity of at least 1.")]
    public int? NewPartQuantity { get; set; }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        await LoadAsync(id);
        return Booking is null ? NotFound() : Page();
    }

    // Parity with mobile's "Finalize & close" (booking_detail_screen.dart) - sets
    // the same status/closed_at columns mobile does, so a booking closed here also
    // drops off mobile's open list and vice versa. Once closed, the Add Job/Add
    // Part forms below hide (see the .cshtml) - matches mobile's `isOpen` gating.
    // Update booking phase (both roles, use case "Update booking phase"). Goes
    // through the same update_booking_phase function as mobile; the database
    // webhook then pushes a notification to the customer.
    public async Task<IActionResult> OnPostPhaseAsync(Guid id)
    {
        ModelState.Clear();
        await LoadAsync(id);
        if (Booking is null)
        {
            return NotFound();
        }

        if (Booking.Status == "closed")
        {
            LoadError = "A closed booking's phase can't be changed - reopen it first.";
            return Page();
        }

        if (NewPhase is null || !SelectablePhases.Any(p => p.Key == NewPhase))
        {
            LoadError = "Choose a phase.";
            return Page();
        }

        try
        {
            await supabase.Rpc("update_booking_phase", new { p_booking_id = id, p_phase = NewPhase });
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't update the phase: {ex.Message}";
            return Page();
        }

        return RedirectToPage(new { id });
    }

    public async Task<IActionResult> OnPostFinalizeAsync(Guid id)
    {
        ModelState.Clear();
        await LoadAsync(id);
        if (Booking is null)
        {
            return NotFound();
        }

        if (!IsAdmin)
        {
            // Server-side, not just a hidden button - a non-admin POSTing this
            // handler directly must be rejected the same as one who never saw
            // the button at all.
            LoadError = "Only an admin can finalize a booking.";
            return Page();
        }

        try
        {
            await supabase.From<Booking>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Set(x => x.Status!, "closed")
                .Set(x => x.Phase!, "finalized")
                .Set(x => x.ClosedAt!, DateTime.UtcNow)
                .Update();
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't finalize this booking: {ex.Message}";
            return Page();
        }

        return RedirectToPage(new { id });
    }

    // Deleting a booking restocks every part used on it, removes all labour
    // (jobs), then removes the parts and the booking itself - one atomic RPC
    // call so a partial failure can't leave stock restocked with the booking
    // still there, or vice versa. Admin-only, confirmed client-side (matches
    // Finalize's confirm() pattern) and rejected server-side for anyone else.
    // See supabase/migrations/0005_delete_booking_with_restock.sql.
    public async Task<IActionResult> OnPostDeleteAsync(Guid id)
    {
        ModelState.Clear();
        await LoadAsync(id);
        if (Booking is null)
        {
            return NotFound();
        }

        if (!IsAdmin)
        {
            LoadError = "Only an admin can delete a booking.";
            return Page();
        }

        try
        {
            await supabase.Rpc("delete_booking_and_restock", new
            {
                p_booking_id = id,
                p_user_id = supabase.Auth.CurrentUser?.Id,
            });
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't delete this booking: {ex.Message}";
            return Page();
        }

        return RedirectToPage("/Index");
    }

    [BindProperty]
    public string ReopenPassword { get; set; } = string.Empty;

    // No admin/role system exists anywhere in this app (single flat staff
    // login - see web/CLAUDE.md) - "secured through passwords" is implemented
    // as re-verifying the logged-in staff member's own password before undoing
    // a finalize, rather than inventing a role hierarchy nothing else here has.
    // Mobile has no reopen concept at all - this is web-only, deliberately.
    public async Task<IActionResult> OnPostReopenAsync(Guid id)
    {
        ModelState.Clear();
        await LoadAsync(id);
        if (Booking is null)
        {
            return NotFound();
        }

        if (!IsAdmin)
        {
            // Design decision 23 Sept 2026: only an admin can reopen a closed booking.
            // Enforced server-side, not just by hiding the form.
            LoadError = "Only an admin can reopen a booking.";
            return Page();
        }

        var email = User.Identity?.Name;
        if (string.IsNullOrEmpty(email) || string.IsNullOrWhiteSpace(ReopenPassword))
        {
            LoadError = "Enter your password to reopen this booking.";
            return Page();
        }

        try
        {
            var reauth = await supabase.Auth.SignInWithPassword(email, ReopenPassword);
            if (reauth?.AccessToken is null || reauth.RefreshToken is null)
            {
                LoadError = "Incorrect password - booking not reopened.";
                return Page();
            }

            // Re-issue the auth cookie with the freshly-minted token pair, same
            // as Login.cshtml.cs and SupabaseSessionFilter's rotation handling -
            // a review finding pointed out that without this, the sign-in above
            // mints a new session that's never written back to the cookie, which
            // risks a silent logout later if refresh-token rotation is on.
            var claims = new List<Claim>
            {
                new(ClaimTypes.Name, email),
                new(SupabaseClaimTypes.AccessToken, reauth.AccessToken),
                new(SupabaseClaimTypes.RefreshToken, reauth.RefreshToken),
            };
            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(identity));

            await supabase.From<Booking>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Set(x => x.Status!, "checked_in")
                .Set(x => x.Phase!, "ready_for_pickup") // same as mobile's reopen
                .Set(x => x.ClosedAt!, (DateTime?)null)
                .Update();
        }
        catch (Exception)
        {
            // Wrong password throws from SignInWithPassword rather than returning
            // a null-token session in practice - treat any failure here the same
            // way rather than leaking which case it was.
            LoadError = "Incorrect password - booking not reopened.";
            return Page();
        }

        return RedirectToPage(new { id });
    }

    public async Task<IActionResult> OnPostAddJobAsync(Guid id)
    {
        // Both forms on this page bind to the same PageModel, so ASP.NET's
        // automatic model-binding validation populates errors for the OTHER
        // form's [Required] fields too (e.g. submitting Add Part alone showed
        // "Enter a job type." above the unrelated Add Job form) - confirmed
        // live, not obvious from the code. Remove only the OTHER form's keys -
        // ModelState.Clear() (the first fix here) also wiped THIS form's own
        // "Enter a job type." message on a genuine empty submission, since
        // that error is populated by [Required] during model binding before
        // this handler even runs. Found by a review agent, not live testing.
        ModelState.Remove(nameof(NewPartStockItemId));
        ModelState.Remove(nameof(NewPartQuantity));

        await LoadAsync(id, skipJobs: true);
        if (Booking is null)
        {
            return NotFound();
        }

        if (Booking.Status == "closed")
        {
            // Matches mobile's isOpen gating - a finalized booking is read-only.
            JobsError = "This booking is closed and can't be edited.";
            await LoadJobsAsync(id);
            return Page();
        }

        if (string.IsNullOrWhiteSpace(NewJobType))
        {
            // Parts are already loaded (LoadAsync above always loads them, even
            // with skipJobs: true) - only Jobs still needs fetching to re-render.
            await LoadJobsAsync(id);
            return Page();
        }

        try
        {
            await supabase.From<Job>().Insert(new Job
            {
                BookingId = id,
                JobType = NewJobType.Trim(),
                Status = "pending",
            });
        }
        catch (Exception ex)
        {
            // Redirecting here would silently lose this message - the next GET
            // starts with a fresh, empty page model, so JobsError would never
            // actually reach the staff member. Re-render instead (confirmed live:
            // this exact loss happened before this fix, caught by testing an
            // add-job failure, not by reading the code).
            JobsError = $"Couldn't add that job: {ex.Message}";
            return Page();
        }

        return RedirectToPage(new { id });
    }

    public async Task<IActionResult> OnPostAddPartAsync(Guid id)
    {
        // See the matching comment in OnPostAddJobAsync - same cross-form
        // ModelState bleed, other direction. Remove only NewJobType's key so
        // this form's own required-field messages still show.
        ModelState.Remove(nameof(NewJobType));

        await LoadAsync(id, skipJobs: true);
        if (Booking is null)
        {
            return NotFound();
        }
        await LoadJobsAsync(id);

        if (Booking.Status == "closed")
        {
            PartsError = "This booking is closed and can't be edited.";
            return Page();
        }

        if (NewPartStockItemId is null || NewPartQuantity is null or < 1)
        {
            // Parts/options are already loaded (LoadAsync above always loads them).
            return Page();
        }

        try
        {
            var stockItem = await supabase.From<StockItem>().GetByIdAsync(NewPartStockItemId.Value);

            if (stockItem is null)
            {
                PartsError = "That part no longer exists.";
                return Page();
            }

            if (stockItem.QuantityOnHand < NewPartQuantity.Value)
            {
                PartsError = $"Only {stockItem.QuantityOnHand} of \"{stockItem.Name}\" left in stock.";
                return Page();
            }

            // One atomic call does the decrement + both inserts together, so a
            // Postgres function's implicit transaction covers all three writes -
            // a failure partway through rolls back everything instead of leaving
            // stock decremented with no booking_parts/stock_movements row to show
            // for it. An earlier version of this made only the decrement atomic
            // and left the two inserts as separate calls - a review pass found
            // that split could still lose stock silently on a partial failure.
            // See supabase/migrations/0004_atomic_stock_decrement.sql.
            AddBookingPartResult? result;
            try
            {
                var response = await supabase.Rpc("add_booking_part", new
                {
                    p_booking_id = id,
                    p_stock_item_id = stockItem.Id,
                    p_qty = NewPartQuantity.Value,
                    p_unit_price = stockItem.SellPrice,
                    p_user_id = supabase.Auth.CurrentUser?.Id,
                    p_reference = Booking.Registration,
                });
                result = JsonSerializer.Deserialize<List<AddBookingPartResult>>(response.Content ?? "[]")?.FirstOrDefault();
            }
            catch (Exception rpcEx) when (IsAddPartFunctionBroken(rpcEx.Message))
            {
                // Until migration 0009 is run on the live project the database
                // still holds the old text-typed add_booking_part, which fails
                // with 42804 on every call. Do the same three writes directly
                // (the way the mobile app does) so staff aren't blocked.
                result = await AddPartWithoutFunctionAsync(id, stockItem, NewPartQuantity.Value, Booking.Registration);
            }
            if (result is null || !result.Ok)
            {
                // The RPC returns the CURRENT quantity_on_hand, not the stale
                // pre-check value above - a review finding was that reusing the
                // stale number here could understate/overstate what's actually
                // left by the time a concurrent request wins the race.
                var remaining = result?.QuantityOnHand ?? stockItem.QuantityOnHand;
                PartsError = $"Only {remaining} of \"{stockItem.Name}\" left in stock (someone else just used some) - refresh and try again.";
                return Page();
            }
        }
        catch (Exception ex)
        {
            // Same redirect-swallows-the-message issue as OnPostAddJobAsync above -
            // confirmed live while testing this exact path (the RPC call above
            // throwing before its migration is applied is a real instance of it).
            PartsError = $"Couldn't add that part: {ex.Message}";
            return Page();
        }

        return RedirectToPage(new { id });
    }

    // 42804 = the old text overload; PGRST202/203 = function missing or two
    // ambiguous overloads. Anything else (stock rules, network) is a real error.
    private static bool IsAddPartFunctionBroken(string message) =>
        message.Contains("42804") || message.Contains("PGRST202") || message.Contains("PGRST203");

    // Fallback for add_booking_part. Not one transaction, so each step undoes
    // the earlier ones if it fails. The stock decrement only succeeds if the
    // quantity is still the value we read, so two people using the same part
    // at once can't both take the last one.
    private async Task<AddBookingPartResult> AddPartWithoutFunctionAsync(Guid bookingId, StockItem item, int qty, string? reference)
    {
        var current = await supabase.From<StockItem>().GetByIdAsync(item.Id);
        if (current is null || current.QuantityOnHand < qty)
        {
            return new AddBookingPartResult(false, current?.QuantityOnHand ?? 0);
        }

        var decremented = await supabase.From<StockItem>()
            .Where(x => x.Id == item.Id)
            .Where(x => x.QuantityOnHand == current.QuantityOnHand)
            .Set(x => x.QuantityOnHand, current.QuantityOnHand - qty)
            .Update();
        if (decremented.Models.Count == 0)
        {
            var latest = await supabase.From<StockItem>().GetByIdAsync(item.Id);
            return new AddBookingPartResult(false, latest?.QuantityOnHand ?? 0);
        }

        async Task RestoreStockAsync() => await supabase.From<StockItem>()
            .Where(x => x.Id == item.Id)
            .Set(x => x.QuantityOnHand, current.QuantityOnHand)
            .Update();

        BookingPart? part;
        try
        {
            var inserted = await supabase.From<BookingPart>().Insert(new BookingPart
            {
                BookingId = bookingId,
                StockItemId = item.Id,
                Quantity = qty,
                UnitPrice = item.SellPrice,
            });
            part = inserted.Models.FirstOrDefault();
        }
        catch
        {
            await RestoreStockAsync();
            throw;
        }

        try
        {
            await supabase.From<StockMovement>().Insert(new StockMovement
            {
                ItemId = item.Id,
                Type = "out",
                Quantity = qty,
                CostAtTime = current.CostPrice,
                Reference = reference,
                UserId = supabase.Auth.CurrentUser?.Id,
            });
        }
        catch
        {
            if (part is not null)
            {
                await supabase.From<BookingPart>().Where(x => x.Id == part.Id).Delete();
            }
            await RestoreStockAsync();
            throw;
        }

        return new AddBookingPartResult(true, current.QuantityOnHand - qty);
    }

    private async Task LoadAsync(Guid id, bool skipJobs = false)
    {
        try
        {
            Booking = await supabase.From<Booking>().GetByIdAsync(id);
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't load this booking from Supabase: {ex.Message}";
        }

        if (Booking is null)
        {
            return;
        }

        if (!skipJobs)
        {
            await LoadJobsAsync(id);
        }
        await LoadPartsAsync(id);
    }

    private async Task LoadJobsAsync(Guid id)
    {
        try
        {
            var jobs = await supabase.From<Job>()
                .Filter("booking_id", Constants.Operator.Equals, id.ToString())
                .Order("created_at", Constants.Ordering.Descending)
                .Get();
            Jobs = jobs.Models;
        }
        catch (Exception ex)
        {
            // Most likely: the `jobs` table doesn't exist yet in this Supabase project
            // (see web/CLAUDE.md and supabase/migrations/0001_create_jobs_table.sql).
            JobsError = $"Couldn't load jobs for this booking: {ex.Message}";
        }
    }

    private async Task LoadPartsAsync(Guid id)
    {
        try
        {
            var parts = await supabase.From<BookingPart>()
                .Filter("booking_id", Constants.Operator.Equals, id.ToString())
                .Order("created_at", Constants.Ordering.Descending)
                .Get();
            PartsUsed = parts.Models;

            var stockItems = await supabase.From<StockItem>().Order("name", Constants.Ordering.Ascending).Get();
            StockItemsById = stockItems.Models.ToDictionary(s => s.Id, s => s);
            StockItemOptions = stockItems.Models
                .Select(s => new SelectListItem($"{s.Name} ({s.QuantityOnHand} on hand)", s.Id.ToString()))
                .ToList();
        }
        catch (Exception ex)
        {
            PartsError = $"Couldn't load parts for this booking: {ex.Message}";
        }
    }
}
