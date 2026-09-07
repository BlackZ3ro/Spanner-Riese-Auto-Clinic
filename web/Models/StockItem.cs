using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

[Table("stock_items")]
public class StockItem : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("sku")]
    public string Sku { get; set; } = string.Empty;

    [Column("name")]
    public string Name { get; set; } = string.Empty;

    [Column("category_id")]
    public Guid? CategoryId { get; set; }

    [Column("supplier_id")]
    public Guid? SupplierId { get; set; }

    [Column("cost_price")]
    public decimal CostPrice { get; set; }

    [Column("sell_price")]
    public decimal SellPrice { get; set; }

    [Column("quantity_on_hand")]
    public int QuantityOnHand { get; set; }

    [Column("reorder_level")]
    public int ReorderLevel { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }
}
