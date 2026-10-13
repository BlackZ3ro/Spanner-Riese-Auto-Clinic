using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using Spanner.Web.Models;

namespace Spanner.Web.Services;

/// <summary>
/// FR-07: a booking-wide invoice (parts + labour across every job on the booking),
/// not a per-job one - see web/CLAUDE.md for why (booking_parts has no job_id).
/// Generated on demand; nothing is persisted, since no `invoices` table exists yet.
/// </summary>
public class BookingInvoiceDocument(
    Booking booking,
    List<Job> jobs,
    List<BookingPart> parts,
    Dictionary<Guid, StockItem> stockItemsById) : IDocument
{
    public DocumentMetadata GetMetadata() => DocumentMetadata.Default;
    public DocumentSettings GetSettings() => DocumentSettings.Default;

    public void Compose(IDocumentContainer container)
    {
        container.Page(page =>
        {
            page.Size(PageSizes.A4);
            page.Margin(2, Unit.Centimetre);
            page.DefaultTextStyle(x => x.FontSize(11));

            // Structure/field order/section wording below is matched to mobile's
            // invoice_pdf_service.dart (Riese Auto Clinic / Invoice / Invoice # /
            // Bill to / booked+finalized dates / vehicle block / Parts+Labour
            // tables / totals) so a customer holding one invoice from each app
            // sees the same shape - see web/CLAUDE.md. Two deliberate differences
            // kept, not matched: currency stays en-ZA-formatted ("R4 500,00" via
            // ToString("C"), set app-wide since M3) rather than mobile's plain
            // "R 4500.00", and section labels stay British "Labour" (matching
            // every other page in this app - Jobs/Details, Bookings/Details)
            // rather than mobile's "Labor". Also not replicated: mobile prints
            // the booked/finalized dates twice (once before the vehicle block,
            // once after) - reads as a copy-paste slip, not a design choice, so
            // this only prints them once.
            page.Header().Column(column =>
            {
                column.Item().Text("Riese Auto Clinic").FontSize(20).Bold();
                column.Item().Text("Invoice");
                if (!string.IsNullOrEmpty(booking.InvoiceNumber))
                {
                    column.Item().Text($"Invoice #: {booking.InvoiceNumber}").Bold();
                }
            });

            page.Content().PaddingVertical(10).Column(column =>
            {
                column.Spacing(15);

                if (!string.IsNullOrEmpty(booking.CustomerName))
                {
                    column.Item().Column(bill =>
                    {
                        bill.Item().Text("Bill to:").Bold();
                        bill.Item().Text(booking.CustomerName);
                        if (!string.IsNullOrEmpty(booking.CustomerPhone)) bill.Item().Text(booking.CustomerPhone);
                        if (!string.IsNullOrEmpty(booking.CustomerEmail)) bill.Item().Text(booking.CustomerEmail!);
                        if (!string.IsNullOrEmpty(booking.CustomerCompany)) bill.Item().Text(booking.CustomerCompany!);
                    });
                }

                column.Item().Column(dates =>
                {
                    dates.Item().Text($"Booked in: {booking.CreatedAt.ToLocalTime():dd MMM yyyy, HH:mm}");
                    if (booking.ClosedAt is { } closedAt)
                    {
                        dates.Item().Text($"Finalized: {closedAt.ToLocalTime():dd MMM yyyy, HH:mm}");
                    }
                });

                column.Item().Column(details =>
                {
                    details.Item().Text($"{booking.Brand} {booking.Model} ({booking.Year})").Bold().FontSize(14);
                    details.Item().Text($"Registration: {booking.Registration}");
                    details.Item().Text($"Kilometers: {booking.Kilometers} km");
                    if (!string.IsNullOrEmpty(booking.EngineSize)) details.Item().Text($"Engine size: {booking.EngineSize}");
                    if (!string.IsNullOrEmpty(booking.EngineCode)) details.Item().Text($"Engine code: {booking.EngineCode}");
                    details.Item().Text($"Transmission: {booking.TransmissionType}");
                });

                var labourJobs = jobs.Where(j => j.LabourHours is not null && j.LabourRate is not null).ToList();
                if (labourJobs.Count > 0)
                {
                    column.Item().Column(section =>
                    {
                        section.Item().Text("Labour").Bold().FontSize(13);
                        section.Item().Table(table =>
                        {
                            table.ColumnsDefinition(c =>
                            {
                                c.RelativeColumn(3);
                                c.RelativeColumn();
                                c.RelativeColumn();
                                c.RelativeColumn();
                            });

                            table.Header(header =>
                            {
                                header.Cell().Text("Job").Bold();
                                header.Cell().Text("Hours").Bold();
                                header.Cell().Text("Rate").Bold();
                                header.Cell().Text("Total").Bold();
                            });

                            foreach (var job in labourJobs)
                            {
                                var cost = job.LabourHours!.Value * job.LabourRate!.Value;
                                table.Cell().Text(job.JobType);
                                table.Cell().Text(job.LabourHours!.Value.ToString("0.##"));
                                table.Cell().Text(job.LabourRate!.Value.ToString("C"));
                                table.Cell().Text(cost.ToString("C"));
                            }
                        });
                    });
                }

                if (parts.Count > 0)
                {
                    column.Item().Column(section =>
                    {
                        section.Item().Text("Parts").Bold().FontSize(13);
                        section.Item().Table(table =>
                        {
                            table.ColumnsDefinition(c =>
                            {
                                c.RelativeColumn(3);
                                c.RelativeColumn();
                                c.RelativeColumn();
                                c.RelativeColumn();
                            });

                            table.Header(header =>
                            {
                                header.Cell().Text("Item").Bold();
                                header.Cell().Text("Qty").Bold();
                                header.Cell().Text("Unit price").Bold();
                                header.Cell().Text("Total").Bold();
                            });

                            foreach (var part in parts)
                            {
                                var name = stockItemsById.TryGetValue(part.StockItemId, out var item)
                                    ? item.Name : "(part no longer exists)";
                                table.Cell().Text(name);
                                table.Cell().Text(part.Quantity.ToString());
                                table.Cell().Text(part.UnitPrice.ToString("C"));
                                table.Cell().Text((part.UnitPrice * part.Quantity).ToString("C"));
                            }
                        });
                    });
                }

                var partsTotal = parts.Sum(p => p.UnitPrice * p.Quantity);
                var labourTotal = labourJobs.Sum(j => j.LabourHours!.Value * j.LabourRate!.Value);
                var grandTotal = partsTotal + labourTotal;

                column.Item().AlignRight().Column(totals =>
                {
                    totals.Item().Text($"Parts total: {partsTotal:C}");
                    totals.Item().Text($"Labour total: {labourTotal:C}");
                    totals.Item().Text($"Grand total: {grandTotal:C}").Bold().FontSize(14);
                });
            });

            page.Footer().AlignCenter().Text("Riese Auto Clinic - generated by Spanner");
        });
    }
}
