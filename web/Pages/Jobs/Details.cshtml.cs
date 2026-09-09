using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Jobs;

public class DetailsModel(Supabase.Client supabase) : PageModel
{
    public Job? Job { get; private set; }
    public Booking? Booking { get; private set; }
    public string? LoadError { get; private set; }
    public string? SaveError { get; private set; }

    [BindProperty]
    [Required(ErrorMessage = "Enter hours worked.")]
    [Range(0, 999, ErrorMessage = "Enter a valid number of hours.")]
    public decimal? LabourHours { get; set; }

    [BindProperty]
    [Required(ErrorMessage = "Enter an hourly rate.")]
    [Range(0, double.MaxValue, ErrorMessage = "Enter a valid rate.")]
    public decimal? LabourRate { get; set; }

    public decimal? LabourCost => LabourHours is { } h && LabourRate is { } r ? h * r : null;

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        await LoadAsync(id);
        if (Job is null)
        {
            return NotFound();
        }

        LabourHours = Job.LabourHours;
        LabourRate = Job.LabourRate;
        return Page();
    }

    public async Task<IActionResult> OnPostSaveHoursAsync(Guid id)
    {
        await LoadAsync(id);
        if (Job is null)
        {
            return NotFound();
        }

        if (!ModelState.IsValid)
        {
            return Page();
        }

        try
        {
            await supabase.From<Job>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Set(x => x.LabourHours!, LabourHours)
                .Set(x => x.LabourRate!, LabourRate)
                .Update();

            return RedirectToPage(new { id });
        }
        catch (Exception ex)
        {
            SaveError = $"Couldn't save labour hours: {ex.Message}";
            return Page();
        }
    }

    public async Task<IActionResult> OnPostMarkCompleteAsync(Guid id)
    {
        await LoadAsync(id);
        if (Job is null)
        {
            return NotFound();
        }

        if (!ModelState.IsValid)
        {
            return Page();
        }

        try
        {
            await supabase.From<Job>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Set(x => x.LabourHours!, LabourHours)
                .Set(x => x.LabourRate!, LabourRate)
                .Set(x => x.Status!, "completed")
                .Set(x => x.CompletedAt!, DateTime.UtcNow)
                .Update();

            return RedirectToPage(new { id });
        }
        catch (Exception ex)
        {
            SaveError = $"Couldn't mark this job complete: {ex.Message}";
            return Page();
        }
    }

    private async Task LoadAsync(Guid id)
    {
        try
        {
            Job = await supabase.From<Job>()
                .Filter("id", Constants.Operator.Equals, id.ToString())
                .Single();

            if (Job is not null)
            {
                Booking = await supabase.From<Booking>()
                    .Filter("id", Constants.Operator.Equals, Job.BookingId.ToString())
                    .Single();
            }
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't load this job from Supabase: {ex.Message}";
        }
    }
}
