import 'package:freezed_annotation/freezed_annotation.dart';
import 'transmission_type.dart';
import 'booking_status.dart';

part 'vehicle_booking.freezed.dart';
part 'vehicle_booking.g.dart';

@freezed
abstract class VehicleBooking with _$VehicleBooking{
  const factory VehicleBooking({
    required String id,
    required String brand,
    required String model,
    required int year,
    String? engineSize,
    required TransmissionType transmissionType,
    required String registration,
    required int kilometers,
    String? engineCode,
    String? imageUrl,
   // @Default(BookingStatus.checkedIn) BookingStatus status,
    DateTime? closedAt,
    //DateTime? createdAt,
  }) = _VehicleBooking;

  factory VehicleBooking.fromJson(Map<String,dynamic> json) =>
    _$VehicleBookingFromJson(json);
}