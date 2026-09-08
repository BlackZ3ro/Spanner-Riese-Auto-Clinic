using Microsoft.AspNetCore.Mvc.RazorPages;
using Spanner.Web.Models;
using Supabase.Postgrest;

namespace Spanner.Web.Pages.Stock;

public class IndexModel(Supabase.Client supabase) : PageModel
{
    public List<StockItem> Items { get; private set; } = new();
    public Dictionary<Guid, string> CategoryNames { get; private set; } = new();
    public Dictionary<Guid, string> SupplierNames { get; private set; } = new();
    public string? LoadError { get; private set; }

    public async Task OnGetAsync()
    {
        try
        {
            var items = await supabase.From<StockItem>().Order("name", Constants.Ordering.Ascending).Get();
            Items = items.Models;

            var categories = await supabase.From<Category>().Get();
            CategoryNames = categories.Models.ToDictionary(c => c.Id, c => c.Name);

            var suppliers = await supabase.From<Supplier>().Get();
            SupplierNames = suppliers.Models.ToDictionary(s => s.Id, s => s.Name);
        }
        catch (Exception ex)
        {
            LoadError = $"Couldn't load stock from Supabase: {ex.Message}";
        }
    }
}
