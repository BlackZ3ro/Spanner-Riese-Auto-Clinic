using System.Text.Json.Serialization;

namespace Spanner.Web.Models;

// Shape returned by the get_booking_by_reference_code database function
// (supabase/migrations/0006) - the same narrow view the mobile customer screen
// uses. Customers never get direct table access; this is all they can see.
public record CustomerBookingView
{
    [JsonPropertyName("reference_code")] public string ReferenceCode { get; init; } = "";
    [JsonPropertyName("invoice_number")] public string? InvoiceNumber { get; init; }
    [JsonPropertyName("brand")] public string Brand { get; init; } = "";
    [JsonPropertyName("model")] public string Model { get; init; } = "";
    [JsonPropertyName("year")] public int Year { get; init; }
    [JsonPropertyName("registration")] public string Registration { get; init; } = "";
    [JsonPropertyName("image_url")] public string? ImageUrl { get; init; }
    [JsonPropertyName("phase")] public string Phase { get; init; } = "booked_in";
    [JsonPropertyName("status")] public string Status { get; init; } = "checked_in";
    [JsonPropertyName("created_at")] public DateTime? CreatedAt { get; init; }
    [JsonPropertyName("closed_at")] public DateTime? ClosedAt { get; init; }
    [JsonPropertyName("parts")] public List<CustomerPartView> Parts { get; init; } = [];
    [JsonPropertyName("labor")] public List<CustomerLaborView> Labor { get; init; } = [];
}

public record CustomerPartView
{
    [JsonPropertyName("name")] public string Name { get; init; } = "";
    [JsonPropertyName("quantity")] public int Quantity { get; init; }
}

public record CustomerLaborView
{
    [JsonPropertyName("description")] public string Description { get; init; } = "";
    [JsonPropertyName("hours")] public decimal Hours { get; init; }
}
