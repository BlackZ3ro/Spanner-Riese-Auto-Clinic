using Supabase.Postgrest;
using Supabase.Postgrest.Interfaces;
using Supabase.Postgrest.Models;

namespace Spanner.Web.Services;

public static class PostgrestExtensions
{
    // The ".Filter("id", Equals, id.ToString()).Single()" lookup was copy-pasted
    // near-verbatim across Bookings/Details, Bookings/Invoice and Jobs/Details -
    // one place instead of five near-identical copies.
    public static Task<T?> GetByIdAsync<T>(this IPostgrestTable<T> table, Guid id)
        where T : BaseModel, new()
    {
        return table.Filter("id", Constants.Operator.Equals, id.ToString()).Single();
    }

    // ILike patterns treat unescaped % and _ as wildcards, and \ as their own
    // escape character - a search box isn't a pattern box, so a staff member
    // typing a literal % (or a name/reg that happens to contain one) shouldn't
    // get a degenerate match-everything query. Wrap the escaped term in %...%
    // for a plain substring search. Found by a review agent, not live testing.
    public static string ToSubstringPattern(this string term) =>
        $"%{term.Replace("\\", "\\\\").Replace("%", "\\%").Replace("_", "\\_")}%";
}
