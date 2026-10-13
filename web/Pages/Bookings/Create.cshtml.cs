using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Spanner.Web.Models;
using Spanner.Web.Services;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

public class CreateModel(Supabase.Client supabase) : PageModel
{
    // Values/JSON mapping match mobile's TransmissionType enum (transmission_type.dart)
    // exactly - keep the two in sync if this list ever changes.
    public static readonly IReadOnlyList<SelectListItem> TransmissionOptions =
    [
        new("Manual", "manual"),
        new("Automatic", "automatic"),
        new("CVT", "cvt"),
        new("Semi-automatic", "semi_automatic"),
    ];

    // Mobile added customer_name/customer_phone/customer_email/customer_company
    // directly to the live bookings table (see web/CLAUDE.md "Schema drift") -
    // web never collected this before. Matching mobile's own required fields
    // (name + phone required, email/company optional) rather than inventing a
    // different bar for the same data.
    [BindProperty, Required(ErrorMessage = "Required")]
    [Display(Name = "Customer name")]
    public string CustomerName { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Required")]
    [Display(Name = "Customer phone")]
    public string CustomerPhone { get; set; } = string.Empty;

    [BindProperty]
    [Display(Name = "Customer email (optional)")]
    public string? CustomerEmail { get; set; }

    [BindProperty]
    [Display(Name = "Company (optional)")]
    public string? CustomerCompany { get; set; }

    // Set client-side (see the datalist script in Create.cshtml) when the typed
    // name matches a customer returned by OnGetSearchCustomersAsync - links this
    // booking to that existing customers row instead of just repeating their
    // name/phone as plain text. Left null for a genuinely new customer.
    [BindProperty]
    public Guid? CustomerId { get; set; }

    [BindProperty, Required(ErrorMessage = "Required")]
    public string Brand { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Required")]
    public string Model { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Enter a whole number")]
    [Range(1900, 2100, ErrorMessage = "Enter a whole number")]
    public int? Year { get; set; }

    [BindProperty]
    public string? EngineSize { get; set; }

    [BindProperty]
    public string? EngineCode { get; set; }

    [BindProperty, Required(ErrorMessage = "Required")]
    public string TransmissionType { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Required")]
    public string Registration { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Enter a whole number")]
    [Range(0, int.MaxValue, ErrorMessage = "Enter a whole number")]
    public int? Kilometers { get; set; }

    public string? ErrorMessage { get; set; }

    public void OnGet()
    {
    }

    // Backs the customer name field's native <datalist> autocomplete (see
    // Create.cshtml) - a plain JSON array, not a createServerFn-style page, since
    // this is the only consumer and it's fetched with a simple query-string GET.
    public async Task<JsonResult> OnGetSearchCustomersAsync(string? q)
    {
        if (string.IsNullOrWhiteSpace(q) || q.Trim().Length < 2)
        {
            return new JsonResult(Array.Empty<object>());
        }

        var term = q.Trim().ToSubstringPattern();
        var byNameTask = supabase.From<Customer>().Filter("name", Constants.Operator.ILike, term).Limit(8).Get();
        var byPhoneTask = supabase.From<Customer>().Filter("phone", Constants.Operator.ILike, term).Limit(8).Get();
        await Task.WhenAll(byNameTask, byPhoneTask);

        var candidates = byNameTask.Result.Models.Concat(byPhoneTask.Result.Models)
            .GroupBy(c => c.Id).Select(g => g.First()).Take(8).ToList();

        // A native <datalist> option's value is both what's shown AND what gets
        // filled into the input on selection - there's no separate "label" to
        // disambiguate with without corrupting the name that actually gets
        // submitted. So instead of guessing which same-named customer was meant
        // (the live `customers` table already has several "Gary van Wyk" rows,
        // no dedupe on create - see CLAUDE.md), the client groups by name and
        // refuses to auto-link when a name is ambiguous - see Create.cshtml's
        // script. A review finding caught the original version silently
        // linking to whichever duplicate the API happened to return last.
        var matches = candidates
            .Select(c => new { id = c.Id, name = c.Name, phone = c.Phone, email = c.Email, company = c.Company });

        return new JsonResult(matches);
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        var customerName = CustomerName.Trim();
        var customerPhone = CustomerPhone.Trim();
        var customerEmail = string.IsNullOrWhiteSpace(CustomerEmail) ? null : CustomerEmail.Trim();
        var customerCompany = string.IsNullOrWhiteSpace(CustomerCompany) ? null : CustomerCompany.Trim();

        // Matches mobile's book_in_screen.dart _submit(): if no existing customer
        // was picked from the lookup, create one in `customers` (no dedupe - mobile
        // doesn't dedupe by phone either, e.g. the several "Gary van Wyk" rows
        // already in the live table) so this customer is findable by a future
        // booking's lookup too, from either app. Without this, a customer entered
        // via web could never be found again - only mobile-entered ones could.
        var customerId = CustomerId;
        if (customerId is null)
        {
            var createdCustomer = await supabase.From<Customer>().Insert(new Customer
            {
                Name = customerName,
                Phone = customerPhone,
                Email = customerEmail,
                Company = customerCompany,
            });
            customerId = createdCustomer.Models.First().Id;
        }

        var booking = new Booking
        {
            CustomerId = customerId,
            CustomerName = customerName,
            CustomerPhone = customerPhone,
            CustomerEmail = customerEmail,
            CustomerCompany = customerCompany,
            Brand = Brand.Trim(),
            Model = Model.Trim(),
            Year = Year,
            EngineSize = string.IsNullOrWhiteSpace(EngineSize) ? null : EngineSize.Trim(),
            EngineCode = string.IsNullOrWhiteSpace(EngineCode) ? null : EngineCode.Trim(),
            TransmissionType = TransmissionType,
            Registration = Registration.Trim().ToUpperInvariant(),
            Kilometers = Kilometers,
            // Matches the only status value seen in live data so far; mobile doesn't
            // set this explicitly either (its BookingStatus enum isn't wired up yet -
            // see web/CLAUDE.md), so "checked_in" is the closest thing to a convention.
            Status = "checked_in",
        };

        try
        {
            var result = await supabase.From<Booking>().Insert(booking);
            var created = result.Models.FirstOrDefault();
            return created is not null
                ? RedirectToPage("/Bookings/Details", new { id = created.Id })
                : RedirectToPage("/Index");
        }
        catch (Exception ex)
        {
            ErrorMessage = $"Could not save booking: {ex.Message}";
            return Page();
        }
    }
}
