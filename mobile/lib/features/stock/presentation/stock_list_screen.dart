import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../models/stock_item.dart';
import '../providers/category_provider.dart';
import '../providers/stock_item_provider.dart';
import '../providers/supplier_provider.dart';
import 'add_stock_item_screen.dart';
import 'manage_categories_suppliers_screen.dart';
import 'stock_item_detail_screen.dart';

class StockListScreen extends ConsumerWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      appBar: AppTopBar(
        title: 'Stock',
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined, size: 22),
            tooltip: 'Manage categories & suppliers',
            color: AppColors.textMuted,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ManageCategoriesSuppliersScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading stock: $e')),
        data: (items) => items.isEmpty
            ? Center(
                child: Text(
                  'No stock items yet. Tap + to add one.',
                  style: AppText.body(14, color: AppColors.textMuted),
                ),
              )
            : ListView.separated(
                // Bottom padding keeps the last card clear of the + button.
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _StockTile(
                    item: item,
                    categoryName: categoryName(item.categoryId),
                    supplierName: supplierName(item.supplierId),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => StockItemDetailScreen(itemId: item.id)),
                    ),
                    onDelete: () => _confirmDeleteItem(context, ref, item.id, item.name),
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
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.onGold,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(stockItemProvider.notifier).removeItem(id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not delete: $e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  const _StockTile({
    required this.item,
    required this.categoryName,
    required this.supplierName,
    required this.onTap,
    required this.onDelete,
  });

  final StockItem item;
  final String categoryName;
  final String supplierName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final lowStock = item.quantityOnHand <= item.reorderLevel;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconChip(
            icon: Icons.inventory_2_outlined,
            tone: lowStock ? AppTone.orange : AppTone.gold,
            size: 48,
            radius: 10,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppText.heading(15, weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(
                  '$categoryName \u00b7 $supplierName',
                  style: AppText.body(12.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 3),
                Text('SKU: ${item.sku}', style: AppText.body(12.5, color: AppColors.textMuted)),
                if (lowStock) ...[
                  const SizedBox(height: 7),
                  const StatusPill(label: 'Low stock', tone: AppTone.orange),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.quantityOnHand} on hand',
                style: AppText.body(
                  13.5,
                  weight: FontWeight.w700,
                  color: lowStock ? AppTone.orange.chipText : AppColors.text,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'R${item.sellPrice.toStringAsFixed(2)}',
                style: AppText.body(12.5, color: AppColors.textMuted),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: AppColors.textFaint,
            tooltip: 'Delete',
            visualDensity: VisualDensity.compact,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
