import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_system_riese_auto_clinic/features/stock/presentation/manage_categories_suppliers_screen.dart';
import '../providers/stock_item_provider.dart';
import '../providers/supplier_provider.dart';
import '../providers/category_provider.dart';
import 'add_stock_item_screen.dart';
import 'stock_item_detail_screen.dart';

class StockListScreen extends ConsumerWidget{
  const StockListScreen({super.key});

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(stockItemProvider);
    final categories = ref.watch(categoryProvider).value ?? [];
    final suppliers = ref.watch(supplierProvider).value ?? [];

    String categoryName(String id) {
      final match = categories.where((c) => c.id == id);
      return match.isEmpty ? 'Unknown category' : match.first.name;
    }
    String supplierName(String id) {
      final match = suppliers.where((s) => s.id == id);
      return match.isEmpty ? 'Unknown supplier' : match.first.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Manage categories & suppliers',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ManageCategoriesSuppliersScreen()),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading :() => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading stock: $e')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No stock items yet. Tap + to add one.'))
            : ListView.builder(
               itemCount: items.length,
               itemBuilder: (context, index){
              final item = items[index];
              final lowStock = item.quantityOnHand <= item.reorderLevel;

          return ListTile(
            title: Text(item.name),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => StockItemDetailScreen(itemId: item.id)),
            ),
            subtitle: Text(
              '${categoryName(item.categoryId)} * ${supplierName(item.supplierId)} * SKU: ${item.sku}'
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.quantityOnHand} on hand',
                  style: TextStyle(
                    color: lowStock ? Colors.red : null,
                    fontWeight: lowStock ? FontWeight.bold : null,
                  ),
                ),
                Text('R${item.sellPrice.toStringAsFixed(2)}'),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDeleteItem(context, ref, item.id, item.name),
            ),
          ],
        ),
      );
               },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddStockItemScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteItem(BuildContext context, WidgetRef ref, String id, String name) {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm delete'),
        content: Text('Delete "$name" from stock?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), 
            child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await ref.read(stockItemProvider.notifier).removeItem(id);
                } catch (e) {
                  if (context.mounted) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not delete: $e')));
                    }
                  }
                }
              }, child: const Text('Delete'),
            )
        ],
      )
      );
  }
}