using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Models;

/// <summary>
/// Matches the proposed `jobs` table in supabase/migrations/0001_create_jobs_table.sql -
/// this table does not exist in the live project yet (see web/CLAUDE.md). Queries against
/// it are expected to fail until that migration is applied, and callers handle that.
/// </summary>
[Table("jobs")]
public class Job : BaseModel
{
    [PrimaryKey("id", false)]
    public Guid Id { get; set; }

    [Column("booking_id")]
    public Guid BookingId { get; set; }

    [Column("job_type")]
    public string JobType { get; set; } = string.Empty;

    [Column("status")]
    public string Status { get; set; } = "pending";

    [Column("labour_hours")]
    public decimal? LabourHours { get; set; }

    [Column("labour_rate")]
    public decimal? LabourRate { get; set; }

    // ignoreOnInsert: same pitfall as Booking.CreatedAt - don't let C#'s default
    // DateTime override the DB's `created_at default now()`.
    [Column("created_at", ignoreOnInsert: true)]
    public DateTime CreatedAt { get; set; }

    [Column("completed_at")]
    public DateTime? CompletedAt { get; set; }
}
