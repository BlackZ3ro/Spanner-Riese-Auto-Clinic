import 'package:freezed_annotation/freezed_annotation.dart';

enum BookingPhase{
  @JsonValue('booked_in')
  bookedIn,
  @JsonValue('labor_in_progress')
  laborInProgress,
  @JsonValue('reassembly')
  reassembly,
  @JsonValue('ready_for_pickup')
  readyForPickup,
  @JsonValue('finalized')
  finalized;

  String get displayName {
    switch (this) {
      case BookingPhase.bookedIn:
        return 'Book-in & Inspection';
      case BookingPhase.laborInProgress:
        return 'Labor in progress';
      case BookingPhase.reassembly:
        return 'Reassembly';
      case BookingPhase.readyForPickup:
        return 'Finished - ready for pickup';
      case BookingPhase.finalized:
        return 'Finalized - booked out to customer';
    }
  }

  int get stepNumber => BookingPhase.values.indexOf(this) + 1;

  static List<BookingPhase> get selectable => 
    values.where((p) => p != BookingPhase.finalized).toList();
}