import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/stock_movement_repository.dart';
import '../models/stock_movement.dart';
import 'stock_item_provider.dart';

final stockMovementRepositoryProvider = Provider((ref) => StockMovementRepository());

class StockMovementService {
  StockMovementService(this.ref);
  final Ref ref;

  Future<void> recordMovement ({
    required String itemId,
    required MovementType type,
    required int quantity,
    required double costAtTime,
    String? reference,
    double? newCostPrice,
  }) async {
    final repo = ref.read(stockMovementRepositoryProvider);

    await repo.add(
      itemId: itemId,
      type: type,
      quantity: quantity,
      costAtTime: costAtTime,
      reference: reference,
      userId: null
    );

    final delta = type == MovementType.stockIn ? quantity : -quantity;
    await ref
      .read(stockItemProvider.notifier)
      .adjustedQuantity(itemId, delta, newCostPrice: newCostPrice);
  }
}
final stockMovementServiceProvider = Provider((ref) => StockMovementService(ref));