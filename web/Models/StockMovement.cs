using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

[Table("stock_movements")]
public class StockMovement : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("item_id")]
    public Guid ItemId { get; set; }

    // Matches mobile's MovementType JSON values exactly ('in' / 'out') - see
    // mobile/lib/stock/models/stock_movement.dart.
    [Column("type")]
    public string Type { get; set; } = string.Empty;

    [Column("quantity")]
    public int Quantity { get; set; }

    [Column("cost_at_time")]
    public decimal CostAtTime { get; set; }

    [Column("reference")]
    public string? Reference { get; set; }

    [Column("user_id")]
    public string? UserId { get; set; }

    [Column("timestamp", ignoreOnInsert: true)]
    public DateTime Timestamp { get; set; }
}
