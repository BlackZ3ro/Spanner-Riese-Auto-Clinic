import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/customer_repository.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository());