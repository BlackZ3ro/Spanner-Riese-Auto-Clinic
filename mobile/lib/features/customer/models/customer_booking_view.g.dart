// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_booking_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerBookingView _$CustomerBookingViewFromJson(Map<String, dynamic> json) =>
    _CustomerBookingView(
      referenceCode: json['reference_code'] as String,
      invoiceNumber: json['invoice_number'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      registration: json['registration'] as String,
      imageUrl: json['image_url'] as String?,
      phase: $enumDecode(_$BookingPhaseEnumMap, json['phase']),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      parts: (json['parts'] as List<dynamic>)
          .map((e) => CustomerPartView.fromJson(e as Map<String, dynamic>))
          .toList(),
      labor: (json['labor'] as List<dynamic>)
          .map((e) => CustomerLaborView.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerBookingViewToJson(
  _CustomerBookingView instance,
) => <String, dynamic>{
  'reference_code': instance.referenceCode,
  'invoice_number': instance.invoiceNumber,
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'registration': instance.registration,
  'image_url': instance.imageUrl,
  'phase': _$BookingPhaseEnumMap[instance.phase]!,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'closed_at': instance.closedAt?.toIso8601String(),
  'parts': instance.parts,
  'labor': instance.labor,
};

const _$BookingPhaseEnumMap = {
  BookingPhase.bookedIn: 'booked_in',
  BookingPhase.laborInProgress: 'labor_in_progress',
  BookingPhase.reassembly: 'reassembly',
  BookingPhase.readyForPickup: 'ready_for_pickup',
  BookingPhase.finalized: 'finalized',
};

const _$BookingStatusEnumMap = {
  BookingStatus.checkedIn: 'checked_in',
  BookingStatus.closed: 'closed',
};
