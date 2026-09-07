import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_system_riese_auto_clinic/stock/data/stock_item_repository.dart';
import '../models/stock_item.dart';

final stockItemRepositoryProvider = Provider((ref) => StockItemRepository());

class StockItemNotifier extends AsyncNotifier<List<StockItem>> {
  @override
  Future<List<StockItem>> build(){
    return ref.read(stockItemRepositoryProvider).fetchAll();
  }

  Future<void> addItem({
    required String sku,
    required String name,
    required String categoryId,
    required String supplierId,
    required double costPrice,
    required double sellPrice,
    required int quantityOnHand,
    required int reorderLevel, 
  }) async {
    final repo = ref.read(stockItemRepositoryProvider);
    final newItem = await repo.add(
      sku: sku, 
      name: name, 
      categoryId: categoryId, 
      supplierId: supplierId, 
      costPrice: costPrice, 
      sellPrice: sellPrice, 
      quantityOnHand: quantityOnHand, 
      reorderLevel: reorderLevel,
      );
      final current = state.value ?? [];
      state = AsyncData([...current, newItem]);
  }

  Future<void> removeItem(String id) async {
    final repo = ref.read(stockItemRepositoryProvider);
    await repo.remove(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((i) => i.id != id).toList());
  }

  Future<void> adjustedQuantity(String itemId, int delta, {double? newCostPrice}) async {
    final repo = ref.read(stockItemRepositoryProvider);
    final current = state.value ?? [];
    final item = current.firstWhere((i) => i.id == itemId);
    final updated = await repo.updateQuantityAndCost(
      itemId, 
      item.quantityOnHand + delta,
      newCostPrice:  newCostPrice
      );
    state = AsyncData([
      for (final i in current)
        if (i.id == itemId) updated else i,
    ]);
  }
}

final stockItemProvider = 
  AsyncNotifierProvider<StockItemNotifier, List<StockItem>>(StockItemNotifier.new);