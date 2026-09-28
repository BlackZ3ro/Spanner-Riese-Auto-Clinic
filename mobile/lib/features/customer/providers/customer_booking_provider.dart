import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/customer_booking_repository.dart';

final customerBookingRepositoryProvider = Provider((ref) => CustomerBookingRepository());