// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleBooking _$VehicleBookingFromJson(Map<String, dynamic> json) =>
    _VehicleBooking(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      engineSize: json['engine_size'] as String?,
      transmissionType: $enumDecode(
        _$TransmissionTypeEnumMap,
        json['transmission_type'],
      ),
      registration: json['registration'] as String,
      kilometers: (json['kilometers'] as num).toInt(),
      engineCode: json['engine_code'] as String?,
      imageUrl: json['image_url'] as String?,
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
    );

Map<String, dynamic> _$VehicleBookingToJson(
  _VehicleBooking instance,
) => <String, dynamic>{
  'id': instance.id,
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'engine_size': instance.engineSize,
  'transmission_type': _$TransmissionTypeEnumMap[instance.transmissionType]!,
  'registration': instance.registration,
  'kilometers': instance.kilometers,
  'engine_code': instance.engineCode,
  'image_url': instance.imageUrl,
  'closed_at': instance.closedAt?.toIso8601String(),
};

const _$TransmissionTypeEnumMap = {
  TransmissionType.manual: 'manual',
  TransmissionType.automatic: 'automatic',
  TransmissionType.cvt: 'cvt',
  TransmissionType.semiAutomatic: 'semi_automatic',
};
