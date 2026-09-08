using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

public class DetailsModel(Supabase.Client supabase) : PageModel
{
    public Booking? Booking { get; private set; }
    public List<Job> Jobs { get; private set; } = new();
    public string? LoadError { get; private set; }
    public string? JobsError { get; private set; }

    public List<BookingPart> PartsUsed { get; private set; } = new();
    public Dictionary<Guid, StockItem> StockItemsById { get; private set; } = new();
    public List<SelectListItem> StockItemOptions { get; private set; } = new();
    public string? PartsError { get; private set; }

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

    public async Task<IActionResult> OnPostAddJobAsync(Guid id)
    {
        await LoadAsync(id, skipJobs: true);
        if (Booking is null)
        {
            return NotFound();
        }

        if (string.IsNullOrWhiteSpace(NewJobType))
        {
            await LoadJobsAsync(id);
            await LoadPartsAsync(id);
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
            JobsError = $"Couldn't add that job: {ex.Message}";
        }

        return RedirectToPage(new { id });
    }

    public async Task<IActionResult> OnPostAddPartAsync(Guid id)
    {
        await LoadAsync(id, skipJobs: true);
        if (Booking is null)
        {
            return NotFound();
        }
        await LoadJobsAsync(id);

        if (NewPartStockItemId is null || NewPartQuantity is null or < 1)
        {
            await LoadPartsAsync(id);
            return Page();
        }

        try
        {
            var stockItem = await supabase.From<StockItem>()
                .Filter("id", Constants.Operator.Equals, NewPartStockItemId.Value.ToString())
                .Single();

            if (stockItem is null)
            {
                PartsError = "That part no longer exists.";
                await LoadPartsAsync(id);
                return Page();
            }

            if (stockItem.QuantityOnHand < NewPartQuantity.Value)
            {
                PartsError = $"Only {stockItem.QuantityOnHand} of \"{stockItem.Name}\" left in stock.";
                await LoadPartsAsync(id);
                return Page();
            }

            await supabase.From<BookingPart>().Insert(new BookingPart
            {
                BookingId = id,
                StockItemId = stockItem.Id,
                Quantity = NewPartQuantity.Value,
                UnitPrice = stockItem.SellPrice,
            });

            var newQuantityOnHand = stockItem.QuantityOnHand - NewPartQuantity.Value;
            await supabase.From<StockItem>()
                .Filter("id", Constants.Operator.Equals, stockItem.Id.ToString())
                .Set(x => x.QuantityOnHand!, newQuantityOnHand)
                .Update();

            await supabase.From<StockMovement>().Insert(new StockMovement
            {
                ItemId = stockItem.Id,
                Type = "out",
                Quantity = NewPartQuantity.Value,
                CostAtTime = stockItem.CostPrice,
                Reference = Booking.Registration,
                UserId = supabase.Auth.CurrentUser?.Id,
            });
        }
        catch (Exception ex)
        {
            PartsError = $"Couldn't add that part: {ex.Message}";
        }

        return RedirectToPage(new { id });
    }

    private async Task LoadAsync(Guid id, bool skipJobs = false)
    {
        try
        {
            Booking = await supabase.From<Booking>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Single();
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
