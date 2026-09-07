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

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    [Column("closed_at")]
    public DateTime? ClosedAt { get; set; }
}
