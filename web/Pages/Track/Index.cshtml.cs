using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;

namespace Spanner.Web.Pages.Track;

// Customer repair-status lookup (FR-14), the web counterpart of the mobile
// "I'm a customer" screen. No login: the only thing a visitor can do here is
// call get_booking_by_reference_code, which returns one booking's coarse
// phase, parts and labour lines for an exact, random 8-character code.
// Anonymous users have no direct table access (checked live 7 Oct 2026).
public class IndexModel(Supabase.Client supabase) : PageModel
{
    public record Step(string Key, string Label, string Detail);

    // Same five phases, labels and order as mobile (booking_phase.dart) and the
    // push notification text (send-phase-notification), so a customer sees the
    // same words in the app, on this page and in the notification.
    public static readonly IReadOnlyList<Step> Steps =
    [
        new("booked_in", "Book-in & inspection", "Your vehicle is with us and being checked."),
        new("labor_in_progress", "Labour in progress", "Our mechanics are working on your vehicle."),
        new("reassembly", "Reassembly", "Putting everything back together and testing."),
        new("ready_for_pickup", "Finished - ready for pickup", "All done. You can collect your vehicle."),
        new("finalized", "Finalized - booked out", "Booked out and invoiced. Thank you!"),
    ];

    [BindProperty(SupportsGet = true)]
    public string? Code { get; set; }

    public CustomerBookingView? Booking { get; private set; }
    public string? Error { get; private set; }

    public int CurrentIndex =>
        Booking is null ? -1 : Math.Max(0, Steps.ToList().FindIndex(s => s.Key == Booking.Phase));

    public async Task OnGetAsync()
    {
        var code = Code?.Trim().ToUpperInvariant();
        if (string.IsNullOrEmpty(code))
        {
            return;
        }

        Code = code;
        if (code.Length is < 6 or > 12 || !code.All(char.IsLetterOrDigit))
        {
            Error = "That doesn't look like a reference code. Check your booking slip and try again.";
            return;
        }

        try
        {
            var response = await supabase.Rpc("get_booking_by_reference_code", new { p_code = code });
            var body = response.Content;
            Booking = string.IsNullOrWhiteSpace(body) || body.Trim() == "null"
                ? null
                : JsonSerializer.Deserialize<CustomerBookingView>(body);
            if (Booking is null)
            {
                // Same message whether the code is wrong or never existed.
                Error = "We couldn't find a vehicle with that reference code.";
            }
        }
        catch (Exception)
        {
            Error = "We couldn't check right now. Please try again in a moment.";
        }
    }
}
