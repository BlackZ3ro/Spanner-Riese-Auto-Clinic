using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Spanner.Web.Services;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Jobs;

public class DetailsModel(Supabase.Client supabase) : PageModel
{
    public Job? Job { get; private set; }
    public Booking? Booking { get; private set; }
    public string? LoadError { get; private set; }
    public string? SaveError { get; private set; }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        await LoadAsync(id);
        if (Job is null)
        {
            return NotFound();
        }

        return Page();
    }

    public async Task<IActionResult> OnPostMarkCompleteAsync(Guid id)
    {
        await LoadAsync(id);
        if (Job is null)
        {
            return NotFound();
        }

        try
        {
            await CompleteAsync(id);
            return RedirectToPage(new { id });
        }
        catch (Exception ex)
        {
            SaveError = $"Couldn't mark this job complete: {ex.Message}";
            return Page();
        }
    }

    private Task CompleteAsync(Guid id) =>
        supabase.From<Job>()
            .Filter("id", Constants.Operator.Equals, id.ToString())
            .Set(x => x.Status!, "completed")
            .Set(x => x.CompletedAt!, DateTime.UtcNow)
            .Update();

    private async Task LoadAsync(Guid id)
    {
        try
        {
            Job = await supabase.From<Job>().GetByIdAsync(id);

            if (Job is not null)
            {
                Booking = await supabase.From<Booking>().GetByIdAsync(Job.BookingId);
            }
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't load this job from Supabase: {ex.Message}";
        }
    }
}
