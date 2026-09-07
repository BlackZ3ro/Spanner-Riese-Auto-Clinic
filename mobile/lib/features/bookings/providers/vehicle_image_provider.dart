import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vehicle_image_service.dart';

final vehicleImageServiceProvider = Provider((ref) => VehicleImageService());