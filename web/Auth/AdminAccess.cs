namespace Spanner.Web.Auth;

// No role/permission schema exists anywhere in this app (single flat staff
// login - see web/CLAUDE.md). Finalize and Delete needing to be admin-only is
// a real requirement now (two named accounts, admin@.../mechanic@...), but
// building a real roles table + RLS is a bigger change than this warrants
// today, and every new migration this session has cost real back-and-forth
// to get right live. An email allowlist in config is the native, no-new-
// schema way to express "these specific accounts are admins" - configurable
// per environment via appsettings.json / user-secrets, not hardcoded in code.
public static class AdminAccess
{
    public static bool IsAdmin(this IConfiguration config, string? email)
    {
        if (string.IsNullOrEmpty(email))
        {
            return false;
        }

        var admins = config.GetSection("AdminEmails").Get<string[]>() ?? [];
        return admins.Any(a => string.Equals(a, email, StringComparison.OrdinalIgnoreCase));
    }
}
