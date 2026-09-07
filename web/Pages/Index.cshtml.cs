using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages;

public class IndexModel(Supabase.Client supabase) : PageModel
{
    public List<Booking> OpenBookings { get; private set; } = new();
    public List<StockItem> StockItems { get; private set; } = new();
    public string? LoadError { get; private set; }

    public async Task OnGetAsync()
    {
        try
        {
            var bookings = await supabase.From<Booking>()
                .Filter<string>("closed_at", Constants.Operator.Is, null)
                .Order("created_at", Constants.Ordering.Descending)
                .Get();
            OpenBookings = bookings.Models;

            var stock = await supabase.From<StockItem>()
                .Order("quantity_on_hand", Constants.Ordering.Ascending)
                .Get();
            StockItems = stock.Models;
        }
        catch (Exception ex)
        {
            // Missing/invalid config, RLS denying the anon role, network issues, etc. -
            // show a plain message instead of a crashed page (NFR-03).
            LoadError = $"Couldn't load live data from Supabase: {ex.Message}";
        }
    }
}
