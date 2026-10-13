using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using QuestPDF.Fluent;
using Spanner.Web.Models;
using Spanner.Web.Services;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Bookings;

public class InvoiceModel(Supabase.Client supabase) : PageModel
{
    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        Booking? booking;
        try
        {
            booking = await supabase.From<Booking>().GetByIdAsync(id);
        }
        catch (Exception ex)
        {
            // Matches every other page's NFR-03 handling - a Supabase hiccup here
            // should show a clean message instead of a raw 500, since this page
            // never renders a view of its own to redirect state back into.
            return Content($"Couldn't generate the invoice: {ex.Message}", "text/plain");
        }

        if (booking is null)
        {
            return NotFound();
        }

        try
        {
            var jobs = (await supabase.From<Job>()
                .Filter("booking_id", Constants.Operator.Equals, id.ToString())
                .Get()).Models;

            var parts = (await supabase.From<BookingPart>()
                .Filter("booking_id", Constants.Operator.Equals, id.ToString())
                .Get()).Models;

            // Only fetch the stock items this booking actually used, not the
            // whole catalog - fine at today's volume, but no reason to scale
            // this query with the size of the stock table instead of the size
            // of this one invoice.
            var stockItemIds = parts.Select(p => p.StockItemId.ToString()).Distinct().ToList();
            var stockItems = stockItemIds.Count == 0
                ? new Dictionary<Guid, StockItem>()
                : (await supabase.From<StockItem>()
                    .Filter("id", Constants.Operator.In, stockItemIds)
                    .Get()).Models.ToDictionary(s => s.Id, s => s);

            var document = new BookingInvoiceDocument(booking, jobs, parts, stockItems);
            var pdfBytes = document.GeneratePdf();

            var registrationSlug = booking.Registration?.Replace(" ", "") ?? booking.Id.ToString();
            var fileName = $"invoice-{registrationSlug}-{DateTime.Now:yyyyMMdd}.pdf";
            return File(pdfBytes, "application/pdf", fileName);
        }
        catch (Exception ex)
        {
            return Content($"Couldn't generate the invoice: {ex.Message}", "text/plain");
        }
    }
}
