using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

/// <summary>
/// The one labour ledger for both apps: the `booking_labor` table the mobile app
/// already writes (booking_labor_repository.dart). The website used to keep labour
/// on `jobs` instead, so the two invoices could disagree (decided 30 Oct 2026).
/// </summary>
[Table("booking_labor")]
public class BookingLabor : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("booking_id")]
    public Guid BookingId { get; set; }

    [Column("description")]
    public string Description { get; set; } = string.Empty;

    [Column("hours")]
    public decimal Hours { get; set; }

    [Column("rate")]
    public decimal Rate { get; set; }

    [Column("price")]
    public decimal Price { get; set; }

    // Same pitfall as Booking.CreatedAt: never send C#'s default DateTime on insert.
    [Column("created_at", ignoreOnInsert: true)]
    public DateTime CreatedAt { get; set; }
}
