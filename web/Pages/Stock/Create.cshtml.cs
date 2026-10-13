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

    // Not [Required] - either an existing id OR a new-name text box below must be
    // filled, checked manually in OnPostAsync (see there for why).
    [BindProperty]
    public Guid? CategoryId { get; set; }

    [BindProperty]
    [Display(Name = "Or add a new category")]
    public string? NewCategoryName { get; set; }

    [BindProperty]
    public Guid? SupplierId { get; set; }

    [BindProperty]
    [Display(Name = "Or add a new supplier")]
    public string? NewSupplierName { get; set; }

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

        if (CategoryId is null && string.IsNullOrWhiteSpace(NewCategoryName))
        {
            ErrorMessage = "Select a category or enter a new one.";
            return Page();
        }
        if (SupplierId is null && string.IsNullOrWhiteSpace(NewSupplierName))
        {
            ErrorMessage = "Select a supplier or enter a new one.";
            return Page();
        }

        try
        {
            // Independent inserts (different tables, no FK between them) - run
            // together instead of one after another when both are new.
            var categoryTask = CategoryId is null
                ? supabase.From<Category>().Insert(new Category { Name = NewCategoryName!.Trim() })
                : null;
            var supplierTask = SupplierId is null
                ? supabase.From<Supplier>().Insert(new Supplier { Name = NewSupplierName!.Trim() })
                : null;
            if (categoryTask is not null && supplierTask is not null) await Task.WhenAll(categoryTask, supplierTask);
            else if (categoryTask is not null) await categoryTask;
            else if (supplierTask is not null) await supplierTask;

            var categoryId = CategoryId ?? categoryTask!.Result.Models.First().Id;
            var supplierId = SupplierId ?? supplierTask!.Result.Models.First().Id;

            await supabase.From<StockItem>().Insert(new StockItem
            {
                Sku = Sku.Trim(),
                Name = Name.Trim(),
                CategoryId = categoryId,
                SupplierId = supplierId,
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
        try
        {
            var categoriesTask = supabase.From<Category>().Order("name", Supabase.Postgrest.Constants.Ordering.Ascending).Get();
            var suppliersTask = supabase.From<Supplier>().Order("name", Supabase.Postgrest.Constants.Ordering.Ascending).Get();
            await Task.WhenAll(categoriesTask, suppliersTask);

            CategoryOptions = categoriesTask.Result.Models
                .Select(c => new SelectListItem(c.Name, c.Id.ToString()))
                .ToList();
            SupplierOptions = suppliersTask.Result.Models
                .Select(s => new SelectListItem(s.Name, s.Id.ToString()))
                .ToList();
        }
        catch (Exception ex)
        {
            // Matches Stock/Index's NFR-03 handling - a Supabase hiccup shouldn't
            // 500 the "add stock item" page.
            ErrorMessage = $"Couldn't load categories/suppliers from Supabase: {ex.Message}";
        }
    }
}
