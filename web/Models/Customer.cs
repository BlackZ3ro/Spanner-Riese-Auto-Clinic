using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

// Added to the live schema by mobile alongside bookings.customer_* (see
// web/CLAUDE.md "Schema drift") - matches mobile/lib/features/bookings/models/customer.dart.
[Table("customers")]
public class Customer : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("name")]
    public string Name { get; set; } = string.Empty;

    [Column("phone")]
    public string Phone { get; set; } = string.Empty;

    [Column("email")]
    public string? Email { get; set; }

    [Column("company")]
    public string? Company { get; set; }

    [Column("created_at", ignoreOnInsert: true)]
    public DateTime CreatedAt { get; set; }
}
