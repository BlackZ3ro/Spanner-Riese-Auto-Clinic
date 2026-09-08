using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

public class DetailsModel(Supabase.Client supabase) : PageModel
{
    public Booking? Booking { get; private set; }
    public List<Job> Jobs { get; private set; } = new();
    public string? LoadError { get; private set; }
    public string? JobsError { get; private set; }

    [BindProperty]
    [Required(ErrorMessage = "Enter a job type.")]
    public string NewJobType { get; set; } = string.Empty;

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

        if (!ModelState.IsValid)
        {
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
            JobsError = $"Couldn't add that job: {ex.Message}";
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

        if (!skipJobs && Booking is not null)
        {
            await LoadJobsAsync(id);
        }
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
}
