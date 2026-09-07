using Microsoft.AspNetCore.Authentication.Cookies;
using Spanner.Web.Auth;
using Spanner.Web.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages(options =>
{
    // FR-12: every page requires a logged-in staff member, except the login page itself.
    options.Conventions.AuthorizeFolder("/");
    options.Conventions.AllowAnonymousToPage("/Account/Login");
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
            Console.WriteLine($"[Supabase] Connected successfully to {settings.Url}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[Supabase] Connection failed: {ex.Message}");
        }
    }
}

app.Run();
