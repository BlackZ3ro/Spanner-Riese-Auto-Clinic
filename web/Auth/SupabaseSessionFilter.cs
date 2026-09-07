using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Spanner.Web.Auth;

/// <summary>
/// Restores the logged-in staff member's Supabase session on the (per-request)
/// Supabase client, so Postgrest queries run under their access token and
/// respect Row Level Security - rather than the anon role.
/// </summary>
public class SupabaseSessionFilter(Supabase.Client supabase) : IAsyncPageFilter
{
    public async Task OnPageHandlerExecutionAsync(PageHandlerExecutingContext context, PageHandlerExecutionDelegate next)
    {
        try
        {
            await supabase.InitializeAsync();

            var user = context.HttpContext.User;
            var accessToken = user.FindFirst(SupabaseClaimTypes.AccessToken)?.Value;
            var refreshToken = user.FindFirst(SupabaseClaimTypes.RefreshToken)?.Value;

            if (!string.IsNullOrEmpty(accessToken) && !string.IsNullOrEmpty(refreshToken))
            {
                await supabase.Auth.SetSession(accessToken, refreshToken);
            }
        }
        catch
        {
            // Supabase not reachable/configured - let the page itself decide how to
            // degrade (each page catches its own query failures), don't block the request.
        }

        await next();
    }

    public Task OnPageHandlerSelectionAsync(PageHandlerSelectedContext context) => Task.CompletedTask;
}

public static class SupabaseClaimTypes
{
    public const string AccessToken = "supabase_access_token";
    public const string RefreshToken = "supabase_refresh_token";
}
