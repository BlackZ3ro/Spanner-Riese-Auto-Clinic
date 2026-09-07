import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
import '../providers/supplier_provider.dart';

class ManageCategoriesSuppliersScreen extends ConsumerWidget{
  const ManageCategoriesSuppliersScreen ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catergoriesAsync = ref.watch(categoryProvider);
    final supplierAsync = ref.watch(supplierProvider);

    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar (
        title: const Text('Manage categories & suppliers'),
        bottom: const TabBar(
          tabs: [Tab(text: 'Categories'), Tab(text: 'Suppliers')],
        ),
      ),
      body: TabBarView(
        children: [
          catergoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (categories) => ListView(
              children: [
                for (final category in categories)
                ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(
                      context,
                      'Delete "${category.name}"?',
                      () => ref.read(categoryProvider.notifier).removeCategory(category.id),
                    ) ,
                  ),
                )
              ],
            )
          ),

          supplierAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')), 
            data: (suppliers) => ListView(
              children: [
                for (final supplier in suppliers)
                ListTile(
                  title: Text(supplier.name),
                  trailing: IconButton( 
                  icon: const Icon(Icons.delete_outline),
                  onPressed : () => _confirmDelete(
                    context,
                    'Delete "${supplier.name}"?',
                    () => ref.read(supplierProvider.notifier).removeSupplier(supplier.id),
                  )
                )
                )
              ],
            )
          )
        ]
        )
      )
    );
  }

  void _confirmDelete(BuildContext context, String message, Future<void> Function() onConfirm) {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm delete'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), 
            child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async{
                Navigator.of(dialogContext).pop();
                try {
                  await onConfirm();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not delete - it may still be used by a stock item: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
        ],
      ) 
    );
  }
}