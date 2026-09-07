import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/category_repository.dart';
import '../models/category.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build(){
    return ref.read(categoryRepositoryProvider).fetchAll();
  } 

  Future<Category> addCategory(String name) async{
    final repo = ref.read(categoryRepositoryProvider);
    final newCategory = await repo.add(name);
    final current = state.value ?? [];
    state = AsyncData([...current, newCategory]);
    return newCategory;
  }

  Future<void> removeCategory(String id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.remove(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((c) => c.id != id).toList());
  }
}

final categoryProvider = 
AsyncNotifierProvider<CategoryNotifier, List<Category>>(CategoryNotifier.new);


