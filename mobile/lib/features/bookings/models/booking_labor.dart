import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_labor.freezed.dart';
part 'booking_labor.g.dart';

@freezed
abstract class BookingLabor with _$BookingLabor {
  const factory BookingLabor({
    required String id,
    required String bookingId,
    required String description,
    required double hours,
    required double rate,
    required double price,
    DateTime? createdAt,
  }) = _BookingLabor;

  factory BookingLabor.fromJson(Map<String, dynamic> json) =>
      _$BookingLaborFromJson(json);
}