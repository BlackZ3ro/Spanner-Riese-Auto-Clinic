using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
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

                // SetSession refreshes an expired access token internally, and
                // Supabase can rotate the refresh token when that happens - if we
                // don't write the new pair back to the cookie, the cookie keeps
                // replaying the stale tokens every request until Supabase rejects
                // the old refresh token outright, silently breaking auth (queries
                // start failing under the anon role, which every page's own
                // try/catch then shows as an empty-state, not a "please log in
                // again" prompt).
                var current = supabase.Auth.CurrentSession;
                if (current?.AccessToken is not null && current.RefreshToken is not null &&
                    (current.AccessToken != accessToken || current.RefreshToken != refreshToken))
                {
                    var claims = new List<Claim>
                    {
                        new(ClaimTypes.Name, user.FindFirst(ClaimTypes.Name)?.Value ?? current.User?.Email ?? string.Empty),
                        new(SupabaseClaimTypes.AccessToken, current.AccessToken),
                        new(SupabaseClaimTypes.RefreshToken, current.RefreshToken),
                    };
                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    await context.HttpContext.SignInAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme,
                        new ClaimsPrincipal(identity));
                }
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
