import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

enum MovementType{
  @JsonValue('in')
  stockIn,
  @JsonValue('out')
  stockOut,
}

@freezed 
abstract class StockMovement with _$StockMovement{
  const factory StockMovement({
    required String id,
    required String itemId,
    required MovementType type,
    required int quantity,
    required double costAtTime,
    String? reference,
    String? userId,
    required DateTime timestamp,
  }) = _StockMovement;

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
  _$StockMovementFromJson(json);
}