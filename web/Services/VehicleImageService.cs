using System.Text.Json;

namespace Spanner.Web.Services;

/// <summary>
/// Direct port of mobile/lib/features/bookings/data/vehicle_image_service.dart -
/// same Wikimedia Commons search, same query shape, same fallback (retry without a
/// trailing year). FR-13: best-effort visual aid, never authoritative data - a miss
/// is expected, not an error, and callers fall back to plain brand/model/year text.
/// </summary>
public class VehicleImageService(HttpClient httpClient)
{
    public async Task<string?> FindImageUrlAsync(string query)
    {
        var result = await SearchAsync(query);
        if (result is not null)
        {
            return result;
        }

        var withoutYear = System.Text.RegularExpressions.Regex.Replace(query, @"\s+\d{4}$", "").Trim();
        if (withoutYear != query && withoutYear.Length > 0)
        {
            return await SearchAsync(withoutYear);
        }

        return null;
    }

    private async Task<string?> SearchAsync(string query)
    {
        try
        {
            var uri = "https://commons.wikimedia.org/w/api.php" +
                      $"?action=query&generator=search&gsrsearch={Uri.EscapeDataString(query)}" +
                      "&gsrnamespace=6&gsrlimit=1&prop=imageinfo&iiprop=url&format=json&origin=*";

            using var response = await httpClient.GetAsync(uri);
            if (!response.IsSuccessStatusCode)
            {
                return null;
            }

            using var stream = await response.Content.ReadAsStreamAsync();
            using var doc = await JsonDocument.ParseAsync(stream);

            if (!doc.RootElement.TryGetProperty("query", out var queryEl) ||
                !queryEl.TryGetProperty("pages", out var pagesEl))
            {
                return null;
            }

            foreach (var page in pagesEl.EnumerateObject())
            {
                if (page.Value.TryGetProperty("imageinfo", out var imageInfoEl) &&
                    imageInfoEl.ValueKind == JsonValueKind.Array &&
                    imageInfoEl.GetArrayLength() > 0)
                {
                    return imageInfoEl[0].GetProperty("url").GetString();
                }
            }

            return null;
        }
        catch
        {
            // Network hiccup, unexpected response shape, etc. - a missing reference
            // image is an expected outcome here, not something to surface as an error.
            return null;
        }
    }
}
