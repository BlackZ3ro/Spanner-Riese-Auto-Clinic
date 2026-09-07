import 'package:freezed_annotation/freezed_annotation.dart';

enum TransmissionType {
  @JsonValue('manual')
  manual,
  @JsonValue('automatic')
  automatic,
  @JsonValue('cvt')
  cvt,
  @JsonValue('semi_automatic')
  semiAutomatic;

  String get displayName {
    switch (this) {
      case TransmissionType.manual:
        return 'Manual';
      case TransmissionType.automatic:
        return 'Automatic';
      case TransmissionType.cvt:
        return 'CVT';
      case TransmissionType.semiAutomatic:
        return 'Semi-automatic';
    }
  }
}