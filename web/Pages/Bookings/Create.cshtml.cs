using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Spanner.Web.Models;

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

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        var booking = new Booking
        {
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
