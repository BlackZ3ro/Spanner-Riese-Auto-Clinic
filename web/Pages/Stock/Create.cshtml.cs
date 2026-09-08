using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Spanner.Web.Models;

namespace Spanner.Web.Pages.Stock;

public class CreateModel(Supabase.Client supabase) : PageModel
{
    [BindProperty, Required(ErrorMessage = "Required")]
    public string Sku { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Required")]
    public string Name { get; set; } = string.Empty;

    [BindProperty, Required(ErrorMessage = "Required")]
    public Guid? CategoryId { get; set; }

    [BindProperty, Required(ErrorMessage = "Required")]
    public Guid? SupplierId { get; set; }

    [BindProperty, Required(ErrorMessage = "Required")]
    [Range(0, double.MaxValue, ErrorMessage = "Enter a valid amount")]
    public decimal? CostPrice { get; set; }

    [BindProperty, Required(ErrorMessage = "Required")]
    [Range(0, double.MaxValue, ErrorMessage = "Enter a valid amount")]
    public decimal? SellPrice { get; set; }

    [BindProperty, Required(ErrorMessage = "Enter a whole number")]
    [Range(0, int.MaxValue, ErrorMessage = "Enter a whole number")]
    public int? QuantityOnHand { get; set; }

    [BindProperty, Required(ErrorMessage = "Enter a whole number")]
    [Range(0, int.MaxValue, ErrorMessage = "Enter a whole number")]
    public int? ReorderLevel { get; set; }

    public List<SelectListItem> CategoryOptions { get; private set; } = new();
    public List<SelectListItem> SupplierOptions { get; private set; } = new();
    public string? ErrorMessage { get; set; }

    public async Task OnGetAsync()
    {
        await LoadOptionsAsync();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        await LoadOptionsAsync();

        if (!ModelState.IsValid)
        {
            return Page();
        }

        try
        {
            await supabase.From<StockItem>().Insert(new StockItem
            {
                Sku = Sku.Trim(),
                Name = Name.Trim(),
                CategoryId = CategoryId,
                SupplierId = SupplierId,
                CostPrice = CostPrice!.Value,
                SellPrice = SellPrice!.Value,
                QuantityOnHand = QuantityOnHand!.Value,
                ReorderLevel = ReorderLevel!.Value,
            });

            return RedirectToPage("/Stock/Index");
        }
        catch (Exception ex)
        {
            ErrorMessage = $"Could not save this part: {ex.Message}";
            return Page();
        }
    }

    private async Task LoadOptionsAsync()
    {
        var categories = await supabase.From<Category>().Order("name", Supabase.Postgrest.Constants.Ordering.Ascending).Get();
        CategoryOptions = categories.Models
            .Select(c => new SelectListItem(c.Name, c.Id.ToString()))
            .ToList();

        var suppliers = await supabase.From<Supplier>().Order("name", Supabase.Postgrest.Constants.Ordering.Ascending).Get();
        SupplierOptions = suppliers.Models
            .Select(s => new SelectListItem(s.Name, s.Id.ToString()))
            .ToList();
    }
}
