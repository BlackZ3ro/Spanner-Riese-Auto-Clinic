using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Spanner.Web.Services;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Vehicles;

public class SearchModel(Supabase.Client supabase, VehicleImageService imageService) : PageModel
{
    // No VIN column exists in this schema (see web/CLAUDE.md's real-schema section) -
    // registration is the closest identifying field a vehicle keeps across repeat
    // visits, so FR-11's "search by VIN or licence plate" searches registration.
    public string? Query { get; set; }
    public List<Booking> Results { get; private set; } = new();
    public Dictionary<Guid, List<Job>> JobsByBooking { get; private set; } = new();
    public string? ImageUrl { get; private set; }
    public string? SearchError { get; private set; }

    public async Task OnGetAsync(string? q)
    {
        Query = q;
        if (string.IsNullOrWhiteSpace(q))
        {
            return;
        }

        try
        {
            var bookings = await supabase.From<Booking>()
                .Filter("registration", Constants.Operator.ILike, $"%{q.Trim()}%")
                .Order("created_at", Constants.Ordering.Descending)
                .Get();
            Results = bookings.Models;

            foreach (var booking in Results)
            {
                var jobs = await supabase.From<Job>()
                    .Filter("booking_id", Constants.Operator.Equals, booking.Id.ToString())
                    .Order("created_at", Constants.Ordering.Descending)
                    .Get();
                JobsByBooking[booking.Id] = jobs.Models;
            }

            // FR-13: best-effort only - one reference image for the search, from the
            // most recent matching booking's brand/model/year. A miss just means no
            // image shows; it's not treated as an error.
            var first = Results.FirstOrDefault();
            if (first is not null)
            {
                var searchTerm = $"{first.Brand} {first.Model} {first.Year}".Trim();
                ImageUrl = await imageService.FindImageUrlAsync(searchTerm);
            }
        }
        catch (Exception ex)
        {
            SearchError = $"Couldn't search Supabase: {ex.Message}";
        }
    }
}
