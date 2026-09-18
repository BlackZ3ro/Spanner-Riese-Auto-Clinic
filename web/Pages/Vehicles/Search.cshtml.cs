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
    // Also matches customer name/phone (added to the schema by mobile, see
    // CLAUDE.md's "Schema drift" section) - three separate ILike queries merged
    // and deduped in C#, not one OR query. Simplest option that works at this
    // data volume; ponytail: revisit with a single .Or() filter if the booking
    // table ever gets large enough for three round-trips to matter.
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
            var term = q.Trim().ToSubstringPattern();
            var byRegTask = supabase.From<Booking>().Filter("registration", Constants.Operator.ILike, term).Get();
            var byNameTask = supabase.From<Booking>().Filter("customer_name", Constants.Operator.ILike, term).Get();
            var byPhoneTask = supabase.From<Booking>().Filter("customer_phone", Constants.Operator.ILike, term).Get();
            await Task.WhenAll(byRegTask, byNameTask, byPhoneTask);

            Results = byRegTask.Result.Models.Concat(byNameTask.Result.Models).Concat(byPhoneTask.Result.Models)
                .GroupBy(b => b.Id)
                .Select(g => g.First())
                .OrderByDescending(b => b.CreatedAt)
                .ToList();

            var jobTasks = Results.Select(async booking =>
            {
                var jobs = await supabase.From<Job>()
                    .Filter("booking_id", Constants.Operator.Equals, booking.Id.ToString())
                    .Order("created_at", Constants.Ordering.Descending)
                    .Get();
                return (booking.Id, jobs.Models);
            });
            foreach (var (bookingId, jobs) in await Task.WhenAll(jobTasks))
            {
                JobsByBooking[bookingId] = jobs;
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
