import 'package:freezed_annotation/freezed_annotation.dart';
import '../../bookings/models/booking_phase.dart';
import '../../bookings/models/booking_status.dart';
import 'customer_part_view.dart';
import 'customer_labor_view.dart';

part 'customer_booking_view.freezed.dart';
part 'customer_booking_view.g.dart';

@freezed
abstract class CustomerBookingView with _$CustomerBookingView {
  const factory CustomerBookingView({
    required String referenceCode,
    required String invoiceNumber,
    required String brand,
    required String model,
    required int year,
    required String registration,
    String? imageUrl,
    required BookingPhase phase,
    required BookingStatus status,
    DateTime? createdAt,
    DateTime? closedAt,
    required List<CustomerPartView> parts,
    required List<CustomerLaborView> labor,
  }) = _CustomerBookingView;

  factory CustomerBookingView.fromJson(Map<String, dynamic> json) =>
      _$CustomerBookingViewFromJson(json);
}