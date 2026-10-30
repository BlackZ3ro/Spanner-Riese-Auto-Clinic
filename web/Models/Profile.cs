using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

/// <summary>
/// One row per staff member in `profiles` (0006). The mobile app reads the same
/// `role` ('admin' or 'mechanic'), so both apps agree on who is an admin.
/// </summary>
[Table("profiles")]
public class Profile : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("role")]
    public string? Role { get; set; }
}
