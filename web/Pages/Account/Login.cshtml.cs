using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Auth;
using Spanner.Web.Models;

namespace Spanner.Web.Pages.Account;

public class LoginModel(Supabase.Client supabase) : PageModel
{
    [BindProperty]
    [Required(ErrorMessage = "Enter your work email.")]
    [EmailAddress]
    [Display(Name = "Email")]
    public string Email { get; set; } = string.Empty;

    [BindProperty]
    [Required(ErrorMessage = "Enter your password.")]
    [Display(Name = "Password")]
    public string Password { get; set; } = string.Empty;

    public string? ErrorMessage { get; set; }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        try
        {
            await supabase.InitializeAsync();
            var session = await supabase.Auth.SignInWithPassword(Email, Password);

            if (session?.AccessToken is null || session.RefreshToken is null)
            {
                ErrorMessage = "Incorrect email or password.";
                return Page();
            }

            var claims = new List<Claim>
            {
                new(ClaimTypes.Name, session.User?.Email ?? Email),
                new(SupabaseClaimTypes.AccessToken, session.AccessToken),
                new(SupabaseClaimTypes.RefreshToken, session.RefreshToken),
            };

            // Same role the mobile app uses (profiles.role). If it can't be read
            // the claim is left out and AdminAccess falls back to the email list.
            var role = await ReadRoleAsync(session.User?.Id);
            if (role is not null)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }
            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(identity));

            return RedirectToPage("/Index");
        }
        catch (Exception ex)
        {
            // Wrong password, unreachable Supabase project, missing config, etc. -
            // staff should see "something's wrong", not a crash (NFR-03).
            // Supabase reports a wrong password as a JSON error body
            // ("invalid_credentials"), which isn't for staff to read (NFR-01).
            ErrorMessage = ex.Message.Contains("invalid_credentials") || ex.Message.Contains("Invalid login credentials")
                ? "Incorrect email or password."
                : $"Couldn't sign in: {ex.Message}";
            return Page();
        }
    }

    private async Task<string?> ReadRoleAsync(string? userId)
    {
        if (!Guid.TryParse(userId, out var id))
        {
            return null;
        }

        try
        {
            var profile = await supabase.From<Profile>()
                .Filter("id", Supabase.Postgrest.Constants.Operator.Equals, id.ToString())
                .Single();
            return profile?.Role?.Trim().ToLowerInvariant();
        }
        catch
        {
            return null;
        }
    }
}
