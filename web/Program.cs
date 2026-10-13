using System.Globalization;
using Microsoft.AspNetCore.Authentication.Cookies;
using Spanner.Web.Auth;
using Spanner.Web.Configuration;
using Spanner.Web.Services;

// Riese Auto-Clinic is a South African workshop - ToString("C") etc. should render
// Rand, not the server OS's default currency.
var zaCulture = new CultureInfo("en-ZA");
CultureInfo.DefaultThreadCurrentCulture = zaCulture;
CultureInfo.DefaultThreadCurrentUICulture = zaCulture;

// Community license is free for this project's use (student/educational, well under
// the revenue threshold) - see questpdf.com/license and web/CLAUDE.md. Required as of
// QuestPDF 2023.12+; without it, PDF generation throws at runtime.
QuestPDF.Settings.License = QuestPDF.Infrastructure.LicenseType.Community;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages(options =>
{
    // FR-12: every page requires a logged-in staff member, except the login page itself.
    options.Conventions.AuthorizeFolder("/");
    options.Conventions.AllowAnonymousToPage("/Account/Login");
    // Customer repair-status lookup (FR-14): public, reference code only.
    options.Conventions.AllowAnonymousToFolder("/Track");
});
builder.Services.Configure<Microsoft.AspNetCore.Mvc.MvcOptions>(options =>
{
    options.Filters.Add(typeof(SupabaseSessionFilter));
});

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";
        options.AccessDeniedPath = "/Account/Login";
    });
builder.Services.AddAuthorization();

builder.Services.Configure<SupabaseSettings>(
    builder.Configuration.GetSection(SupabaseSettings.SectionName));

// Scoped (one per request), not singleton: each request restores its own
// staff member's session (see SupabaseSessionFilter) so Postgrest queries
// respect that user's Row Level Security, instead of sharing one session
// across every visitor.
builder.Services.AddScoped(sp =>
{
    var settings = builder.Configuration
        .GetSection(SupabaseSettings.SectionName)
        .Get<SupabaseSettings>() ?? new SupabaseSettings();

    var options = new Supabase.SupabaseOptions
    {
        AutoConnectRealtime = false
    };

    // Url/AnonKey are read from user secrets (dev) or environment variables
    // (SUPABASE__URL / SUPABASE__ANONKEY) - never hardcoded, never committed.
    return new Supabase.Client(settings.Url, settings.AnonKey, options);
});

// FR-09: one long-lived Realtime subscription shared by every browser tab (via SSE
// in Pages/Realtime/Stream), not a per-request one.
builder.Services.AddSingleton<RealtimeChangeNotifier>();
builder.Services.AddHostedService(sp => sp.GetRequiredService<RealtimeChangeNotifier>());

// Wikimedia rejects requests with no User-Agent (403, "please set a user-agent") -
// this isn't optional, per their robot policy: https://w.wiki/4wJS.
builder.Services.AddHttpClient<VehicleImageService>(client =>
{
    client.DefaultRequestHeaders.UserAgent.ParseAdd(
        "Spanner-RieseAutoClinic/1.0 (ITC327W student project; https://github.com/BlackZ3ro/Spanner-Riese-Auto-Clinic)");
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();
app.MapRazorPages()
   .WithStaticAssets();

// M0 acceptance: confirm the Supabase connection with visible console output,
// without crashing the app when credentials haven't been configured yet.
using (var scope = app.Services.CreateScope())
{
    var settings = scope.ServiceProvider
        .GetRequiredService<Microsoft.Extensions.Options.IOptions<SupabaseSettings>>().Value;

    if (string.IsNullOrWhiteSpace(settings.Url) || string.IsNullOrWhiteSpace(settings.AnonKey))
    {
        Console.WriteLine(
            "[Supabase] No Url/AnonKey configured - skipping connection check. " +
            "Set them with 'dotnet user-secrets set \"Supabase:Url\" \"...\"' and " +
            "'dotnet user-secrets set \"Supabase:AnonKey\" \"...\"'.");
    }
    else
    {
        try
        {
            var client = scope.ServiceProvider.GetRequiredService<Supabase.Client>();
            await client.InitializeAsync();

            // InitializeAsync() only sets up local client state - it succeeds even
            // against an unreachable host (found while testing NFR-03). A real
            // lightweight query is what actually proves the connection works.
            await client.From<Spanner.Web.Models.Booking>().Limit(1).Get();

            Console.WriteLine($"[Supabase] Connected successfully to {settings.Url}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[Supabase] Connection failed: {ex.Message}");
        }
    }
}

app.Run();
