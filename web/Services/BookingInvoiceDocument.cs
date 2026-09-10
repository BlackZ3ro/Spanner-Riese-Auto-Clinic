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

            page.Header().Column(column =>
            {
                column.Item().Text("Riese Auto-Clinic").FontSize(20).Bold();
                column.Item().Text("Invoice").FontSize(14);
            });

            page.Content().PaddingVertical(10).Column(column =>
            {
                column.Spacing(15);

                column.Item().Column(details =>
                {
                    details.Item().Text($"Vehicle: {booking.Brand} {booking.Model} ({booking.Year})");
                    details.Item().Text($"Registration: {booking.Registration}");
                    details.Item().Text($"Booked in: {booking.CreatedAt.ToLocalTime():dd MMM yyyy}");
                    details.Item().Text($"Invoice date: {DateTime.Now:dd MMM yyyy}");
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
                                header.Cell().Text("Cost").Bold();
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
                                header.Cell().Text("Part").Bold();
                                header.Cell().Text("Qty").Bold();
                                header.Cell().Text("Unit price").Bold();
                                header.Cell().Text("Line total").Bold();
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
                    totals.Item().Text($"Total: {grandTotal:C}").Bold().FontSize(14);
                });
            });

            page.Footer().AlignCenter().Text("Riese Auto-Clinic - generated by Spanner");
        });
    }
}
