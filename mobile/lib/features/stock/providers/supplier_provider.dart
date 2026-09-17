import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/supplier_repository.dart';
import '../models/supplier.dart';

final supplierRepositoryProvider = Provider((ref) => SupplierRepository());

class SupplierNotifier extends AsyncNotifier<List<Supplier>> {
  @override
  Future<List<Supplier>> build(){
    return ref.read(supplierRepositoryProvider).fetchAll();
  } 

  Future<Supplier> addSupplier(String name, {String? contactInfo}) async{
    final repo = ref.read(supplierRepositoryProvider);
    final newSupplier = await repo.add(name, contactInfo : contactInfo);
    final current = state.value ?? [];
    state = AsyncData([...current, newSupplier]);
    return newSupplier;
  }

  Future<void> removeSupplier(String id) async {
    final repo = ref.read(supplierRepositoryProvider);
    await repo.remove(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((s) => s.id != id).toList());
  }
}

final supplierProvider = 
AsyncNotifierProvider<SupplierNotifier, List<Supplier>>(SupplierNotifier.new);


