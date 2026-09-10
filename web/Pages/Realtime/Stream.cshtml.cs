using System.Text;
using System.Threading.Channels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Services;

namespace Spanner.Web.Pages.Realtime;

/// <summary>
/// Server-Sent Events endpoint: each connected browser tab gets its own queue fed by
/// RealtimeChangeNotifier's event for as long as the connection stays open, so a
/// change made anywhere (this browser, another tab, direct SQL, mobile once it adds
/// its own Realtime subscriptions) reaches every open Spanner dashboard live.
/// </summary>
public class StreamModel(RealtimeChangeNotifier notifier) : PageModel
{
    public async Task<IActionResult> OnGetAsync(CancellationToken cancellationToken)
    {
        Response.Headers.ContentType = "text/event-stream";
        Response.Headers.CacheControl = "no-cache";

        var queue = Channel.CreateUnbounded<string>();
        void OnChanged(string table) => queue.Writer.TryWrite(table);
        notifier.Changed += OnChanged;

        try
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                var table = await queue.Reader.ReadAsync(cancellationToken);
                var payload = Encoding.UTF8.GetBytes($"data: {table}\n\n");
                await Response.Body.WriteAsync(payload, cancellationToken);
                await Response.Body.FlushAsync(cancellationToken);
            }
        }
        catch (OperationCanceledException)
        {
            // Browser tab closed / navigated away - expected, not an error.
        }
        finally
        {
            notifier.Changed -= OnChanged;
        }

        // We've already streamed the response directly - skip normal page rendering.
        return new EmptyResult();
    }
}
