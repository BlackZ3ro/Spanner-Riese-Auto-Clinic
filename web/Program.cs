using Spanner.Web.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

builder.Services.Configure<SupabaseSettings>(
    builder.Configuration.GetSection(SupabaseSettings.SectionName));

builder.Services.AddSingleton(sp =>
{
    var settings = builder.Configuration
        .GetSection(SupabaseSettings.SectionName)
        .Get<SupabaseSettings>() ?? new SupabaseSettings();

    var options = new Supabase.SupabaseOptions
    {
        AutoConnectRealtime = true
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
