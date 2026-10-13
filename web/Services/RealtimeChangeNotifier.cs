using Spanner.Web.Configuration;
using Supabase.Realtime.PostgresChanges;

namespace Spanner.Web.Services;

/// <summary>
/// FR-09: a single long-lived Supabase Realtime subscription (separate from the
/// per-request scoped client used for normal queries - Realtime needs one
/// persistent connection, not one per HTTP request) that fans changes on
/// bookings/stock_items out to every connected browser via Server-Sent Events.
/// See Pages/Realtime/Stream.cshtml.cs for the SSE endpoint, and the inline
/// script on Pages/Index.cshtml for the browser side.
/// </summary>
public class RealtimeChangeNotifier(IConfiguration configuration, ILogger<RealtimeChangeNotifier> logger) : IHostedService
{
    private Supabase.Client? _client;

    /// <summary>Raised (with the changed table's name) on the Realtime library's own
    /// background thread whenever a subscribed table changes.</summary>
    public event Action<string>? Changed;

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        var settings = configuration.GetSection(SupabaseSettings.SectionName).Get<SupabaseSettings>()
            ?? new SupabaseSettings();

        if (string.IsNullOrWhiteSpace(settings.Url) || string.IsNullOrWhiteSpace(settings.AnonKey))
        {
            logger.LogInformation("[Realtime] No Url/AnonKey configured - live updates disabled.");
            return;
        }

        try
        {
            _client = new Supabase.Client(settings.Url, settings.AnonKey, new Supabase.SupabaseOptions
            {
                AutoConnectRealtime = true
            });
            await _client.InitializeAsync();

            await SubscribeAsync("bookings");
            await SubscribeAsync("stock_items");

            logger.LogInformation("[Realtime] Subscribed to bookings/stock_items changes.");
        }
        catch (Exception ex)
        {
            // Realtime not enabled for these tables yet, network hiccup, etc. - the
            // rest of the app works fine without live updates, so don't crash startup.
            logger.LogWarning("[Realtime] Could not subscribe: {Message}", ex.Message);
        }
    }

    private async Task SubscribeAsync(string table)
    {
        if (_client is null)
        {
            return;
        }

        // The non-obsolete OnPostgresChange() API mis-builds the subscription topic
        // when paired with the 3-arg Channel(name, schema, table) overload (tested:
        // Supabase rejects it with "unmatched topic"). This Register()+
        // AddPostgresChangeHandler() combination is the one that actually works
        // (verified against the real Supabase Realtime server) - keeping it despite
        // the obsolete warning rather than shipping something that silently doesn't
        // subscribe to anything.
#pragma warning disable CS0618
        var channel = _client.Realtime.Channel($"{table}-changes");
        channel.Register(new PostgresChangesOptions("public", table));
        channel.AddPostgresChangeHandler(PostgresChangesOptions.ListenType.All, (_, _) =>
        {
            Changed?.Invoke(table);
        });
#pragma warning restore CS0618
        await channel.Subscribe();
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
