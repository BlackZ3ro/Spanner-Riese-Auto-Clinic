using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

// View section for closed/finalized bookings. Editing lives on the existing
// Bookings/Details page (Reopen unlocks the same Add Job/Add Part forms every
// open booking already uses - no separate edit UI needed for that).
public class ClosedModel(Supabase.Client supabase) : PageModel
{
    public List<Booking> ClosedBookings { get; private set; } = new();
    public string? LoadError { get; private set; }

    public async Task OnGetAsync()
    {
        try
        {
            var bookings = await supabase.From<Booking>()
                .Filter("status", Constants.Operator.Equals, "closed")
                .Order("closed_at", Constants.Ordering.Descending)
                .Get();
            ClosedBookings = bookings.Models;
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't load closed bookings from Supabase: {ex.Message}";
        }
    }
}
