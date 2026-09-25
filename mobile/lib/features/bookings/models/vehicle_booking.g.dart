// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleBooking _$VehicleBookingFromJson(Map<String, dynamic> json) =>
    _VehicleBooking(
      id: json['id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      customerEmail: json['customer_email'] as String?,
      customerCompany: json['customer_company'] as String?,
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
      status:
          $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.checkedIn,
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$VehicleBookingToJson(
  _VehicleBooking instance,
) => <String, dynamic>{
  'id': instance.id,
  'invoice_number': instance.invoiceNumber,
  'customer_id': instance.customerId,
  'customer_name': instance.customerName,
  'customer_phone': instance.customerPhone,
  'customer_email': instance.customerEmail,
  'customer_company': instance.customerCompany,
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'engine_size': instance.engineSize,
  'transmission_type': _$TransmissionTypeEnumMap[instance.transmissionType]!,
  'registration': instance.registration,
  'kilometers': instance.kilometers,
  'engine_code': instance.engineCode,
  'image_url': instance.imageUrl,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'closed_at': instance.closedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$TransmissionTypeEnumMap = {
  TransmissionType.manual: 'manual',
  TransmissionType.automatic: 'automatic',
  TransmissionType.cvt: 'cvt',
  TransmissionType.semiAutomatic: 'semi_automatic',
};

const _$BookingStatusEnumMap = {
  BookingStatus.checkedIn: 'checked_in',
  BookingStatus.closed: 'closed',
};
