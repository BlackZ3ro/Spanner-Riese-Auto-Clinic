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
        var booking = await supabase.From<Booking>()
            .Filter("id", Constants.Operator.Equals, id.ToString())
            .Single();

        if (booking is null)
        {
            return NotFound();
        }

        var jobs = (await supabase.From<Job>()
            .Filter("booking_id", Constants.Operator.Equals, id.ToString())
            .Get()).Models;

        var parts = (await supabase.From<BookingPart>()
            .Filter("booking_id", Constants.Operator.Equals, id.ToString())
            .Get()).Models;

        var stockItems = (await supabase.From<StockItem>().Get()).Models
            .ToDictionary(s => s.Id, s => s);

        var document = new BookingInvoiceDocument(booking, jobs, parts, stockItems);
        var pdfBytes = document.GeneratePdf();

        var fileName = $"invoice-{booking.Registration.Replace(" ", "")}-{DateTime.Now:yyyyMMdd}.pdf";
        return File(pdfBytes, "application/pdf", fileName);
    }
}
