import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_part.freezed.dart';
part 'booking_part.g.dart';

@freezed
abstract class BookingPart with _$BookingPart {
  const factory BookingPart({
    required String id,
    required String bookingId,
    required String stockItemId,
    required int quantity,
    required double unitPrice,
    DateTime? createdAt,
  }) = _BookingPart;

  factory BookingPart.fromJson(Map<String, dynamic> json) => 
  _$BookingPartFromJson(json);
}