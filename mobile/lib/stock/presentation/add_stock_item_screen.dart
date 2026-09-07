import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/prompt_dialog.dart';
import '../models/category.dart';
import '../models/supplier.dart';
import '../providers/category_provider.dart';
import '../providers/supplier_provider.dart';
import '../providers/stock_item_provider.dart';

const _addNewValue = '__add_new__';

class AddStockItemScreen extends ConsumerStatefulWidget{
  const AddStockItemScreen({super.key});

  @override
  ConsumerState<AddStockItemScreen> createState() => _AddStockItemScreenState();

}

class _AddStockItemScreenState extends ConsumerState<AddStockItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _sellController = TextEditingController();
  final _quantityController = TextEditingController(text: '0');
  final _reorderController = TextEditingController(text: '0');

  String? _selectedCategoryId;
  String? _selectedSupplierId;

  @override
  Widget build(BuildContext context){
    final categoriesAsync = ref.watch(categoryProvider);
    final suppliersAsync = ref.watch(supplierProvider);

  return categoriesAsync.when(
    loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    error : (e, _)=> Scaffold(body: Center(child: Text('Error loading categories $e'))),
    data: (categories) => suppliersAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error : (e, _)=> Scaffold(body: Center(child: Text('Error loading suppliers $e'))),
      data: (suppliers) => _buildForm(context, categories, suppliers),
    ),
  );
  }


Widget _buildForm(BuildContext context, List<Category> categories, List<Supplier> suppliers){
    return Scaffold(
      appBar: AppBar(title: const Text('Add stock item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              _buildCategoryDropdown(categories),
              const SizedBox(height: 12),
              _buildSupplierDropdown(suppliers),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Enter a number': null,
              ),
              TextFormField(
                controller: _sellController,
                decoration: const InputDecoration(labelText: 'Sell price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Enter a number': null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Starting quantity'),
                keyboardType:  TextInputType.number,
                validator: (v) => (v == null || int.tryParse(v) == null) ? 'Enter a whole number': null,
              ),
              TextFormField(
                controller: _reorderController,
                decoration: const InputDecoration(labelText: 'Reorder level'),
                keyboardType:  TextInputType.number,
                validator: (v) => (v == null || int.tryParse(v) == null) ? 'Enter a whole number': null,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _submit, child: const Text('Save item')),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCategoryDropdown(List<Category> categories){
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Category'),
      initialValue: _selectedCategoryId,
      items: [
        ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
        const DropdownMenuItem(value: _addNewValue, child: Text('+ Add new category')),
      ],
      onChanged: (value) async{
        if (value == _addNewValue){
          final name = await promptForName(context, 'New Category');
          if (name != null && name.trim().isNotEmpty){
            final newCategory =
            await  ref.read(categoryProvider.notifier).addCategory(name.trim());
            setState(() => _selectedCategoryId = newCategory.id);
          }
        } else{
          setState(() => _selectedCategoryId = value);
        }
      }
    );
  }


  Widget _buildSupplierDropdown(List<Supplier> suppliers){
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Supplier'),
      initialValue: _selectedSupplierId,
      items: [
        ...suppliers.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
        const DropdownMenuItem(value: _addNewValue, child: Text('+ Add new supplier'))
      ],
      onChanged: (value) async {
        if (value == _addNewValue){
          final name = await promptForName(context, 'New Supplier');
          if (name != null && name.trim().isNotEmpty) {
            final newSupplier =
            await ref.read(supplierProvider.notifier).addSupplier(name.trim());
            setState(() => _selectedSupplierId = newSupplier.id);
          }
        } else {
          setState(() => _selectedSupplierId =value);
        }
      }
    );
  }


  void _submit() async {
  if (!_formKey.currentState!.validate()) return;
  if (_selectedCategoryId == null || _selectedSupplierId == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pick a category and supplier')));
    return;
  }

  try {
    await ref.read(stockItemProvider.notifier).addItem(
          sku: _skuController.text.trim(),
          name: _nameController.text.trim(),
          categoryId: _selectedCategoryId!,
          supplierId: _selectedSupplierId!,
          costPrice: double.parse(_costController.text),
          sellPrice: double.parse(_sellController.text),
          quantityOnHand: int.parse(_quantityController.text),
          reorderLevel: int.parse(_reorderController.text),
        );
    if (mounted) Navigator.of(context).pop();
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not save item: $e')));
    }
  }
}
}