using Spanner.Web.Models;
using Spanner.Web.Pages.Track;

namespace Spanner.Web.Services;

// "Send on WhatsApp" on the booking page (Mr G's feedback at the Phase 2
// presentation, 16 Oct 2026): staff send the customer their reference code
// after book-in, then a status update whenever the phase changes.
//
// Uses WhatsApp's free click-to-chat link (https://wa.me/<number>?text=...)
// instead of the paid WhatsApp Business API, so the zero-budget rule (SRS
// Section 2, Economic) still holds. The link opens WhatsApp on the staff
// member's phone or computer with the message already typed; they check it
// and tap Send. No API key, no Meta account, nothing stored.
public static class CustomerWhatsApp
{
    // wa.me needs the number in international form, digits only, no "+" or
    // "00" (e.g. 27821234567). Customers are local, so a 10-digit number that
    // starts with 0 (082 123 4567) is South African. Anything we can't be
    // sure of returns null, and the link opens WhatsApp's contact picker
    // rather than messaging a wrong number.
    public static string? ToWhatsAppNumber(string? phone)
    {
        if (string.IsNullOrWhiteSpace(phone))
        {
            return null;
        }

        var trimmed = phone.Trim();
        var digits = new string(trimmed.Where(char.IsDigit).ToArray());
        if (digits.StartsWith("00"))
        {
            digits = digits[2..];
        }
        else if (!trimmed.StartsWith('+') && digits.Length == 10 && digits[0] == '0')
        {
            digits = "27" + digits[1..];
        }

        // International numbers are at most 15 digits; under 10 isn't a full number.
        return digits.Length is >= 10 and <= 15 && digits[0] != '0' ? digits : null;
    }

    // The public tracking page, if the web app is online. Left blank in
    // appsettings.json while the app only runs on a staff computer, because a
    // localhost link is useless to a customer; the message then points them
    // to the app's "I'm a customer" screen instead.
    public static string? TrackLink(string? publicSiteUrl, string code) =>
        Uri.TryCreate(publicSiteUrl, UriKind.Absolute, out var site) && site.Scheme is "https" or "http"
            ? $"{site.AbsoluteUri.TrimEnd('/')}/Track?code={Uri.EscapeDataString(code)}"
            : null;

    // Same phase labels and wording the customer sees on /Track, in the app
    // and in the push notification (Track/IndexModel.Steps), so all four
    // channels tell one story.
    public static string Message(Booking booking, string? publicSiteUrl)
    {
        var firstName = booking.CustomerName.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();
        var hi = firstName is null ? "Hi" : $"Hi {firstName}";
        var car = $"{booking.Brand} {booking.Model}".Trim()
                  + (string.IsNullOrWhiteSpace(booking.Registration) ? "" : $" ({booking.Registration})");
        var code = booking.ReferenceCode ?? "";

        if (booking.Status == "closed" || booking.Phase == "finalized")
        {
            var invoice = string.IsNullOrEmpty(booking.InvoiceNumber) ? "" : $" (invoice {booking.InvoiceNumber})";
            return $"{hi}, your {car} has been booked out{invoice}. Thank you for choosing Riese Auto-Clinic!";
        }

        var step = IndexModel.Steps.FirstOrDefault(s => s.Key == booking.Phase) ?? IndexModel.Steps[0];
        var text = step.Key == "booked_in"
            ? $"{hi}, your {car} is booked in at Riese Auto-Clinic. Your reference code is {code}."
            : $"{hi}, an update on your {car} from Riese Auto-Clinic: {step.Label}. {step.Detail} Reference code: {code}.";

        var follow = TrackLink(publicSiteUrl, code) is { } url
            ? $" Track it any time: {url}"
            : " To follow it, open the Spanner app, tap \"I'm a customer\" and enter the code.";
        return text + follow;
    }

    public static string Link(Booking booking, string? publicSiteUrl)
    {
        var text = Uri.EscapeDataString(Message(booking, publicSiteUrl));
        return ToWhatsAppNumber(booking.CustomerPhone) is { } number
            ? $"https://wa.me/{number}?text={text}"
            : $"https://wa.me/?text={text}";
    }
}
