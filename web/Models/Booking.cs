using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

[Table("bookings")]
public class Booking : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("brand")]
    public string Brand { get; set; } = string.Empty;

    [Column("model")]
    public string Model { get; set; } = string.Empty;

    [Column("year")]
    public int? Year { get; set; }

    [Column("engine_size")]
    public string? EngineSize { get; set; }

    [Column("transmission_type")]
    public string? TransmissionType { get; set; }

    [Column("registration")]
    public string? Registration { get; set; }

    [Column("kilometers")]
    public long? Kilometers { get; set; }

    [Column("engine_code")]
    public string? EngineCode { get; set; }

    [Column("image_url")]
    public string? ImageUrl { get; set; }

    [Column("status")]
    public string Status { get; set; } = string.Empty;

    // ignoreOnInsert: without this, C#'s default DateTime (0001-01-01) gets sent
    // explicitly on insert and overrides Postgres's own `created_at default now()`.
    [Column("created_at", ignoreOnInsert: true)]
    public DateTime CreatedAt { get; set; }

    [Column("closed_at")]
    public DateTime? ClosedAt { get; set; }

    // Added to the live schema by mobile (Sept 2026, see web/CLAUDE.md "Schema
    // drift" section) - not created by any migration in this repo. InvoiceNumber
    // is DB-generated (a sequence, e.g. "INV-00005") - ignoreOnInsert so a blank
    // C# default doesn't overwrite it, same reasoning as CreatedAt above.
    [Column("invoice_number", ignoreOnInsert: true)]
    public string? InvoiceNumber { get; set; }

    // Added by mobile (Sept 2026, recorded in supabase/migrations/0006): the
    // customer-facing phase and the random reference code customers use to
    // look their car up. Both DB-defaulted, so ignoreOnInsert like the above.
    // Finalize/Reopen here must set Phase too, or a customer keeps seeing
    // "Labor in progress" after a web finalize.
    [Column("phase", ignoreOnInsert: true)]
    public string? Phase { get; set; }

    [Column("reference_code", ignoreOnInsert: true)]
    public string? ReferenceCode { get; set; }

    [Column("customer_id")]
    public Guid? CustomerId { get; set; }

    [Column("customer_name")]
    public string CustomerName { get; set; } = string.Empty;

    [Column("customer_phone")]
    public string CustomerPhone { get; set; } = string.Empty;

    [Column("customer_email")]
    public string? CustomerEmail { get; set; }

    [Column("customer_company")]
    public string? CustomerCompany { get; set; }
}
