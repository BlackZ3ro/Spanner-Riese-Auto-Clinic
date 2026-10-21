import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_item.dart';
import '../models/stock_movement.dart';
import '../providers/stock_item_provider.dart';
import '../providers/stock_movement_service.dart';

class StockItemDetailScreen extends ConsumerWidget {
  const StockItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(stockItemProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Item')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          final matches = items.where((i) => i.id == itemId);
          if (matches.isEmpty) {
            return const Center(child: Text('This item is no longer available.'));
          }
          return _buildBody(context, matches.first);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, StockItem item) {
    final lowStock = item.quantityOnHand <= item.reorderLevel;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('SKU ${item.sku}'),
          const SizedBox(height: 16),
          Text(
            '${item.quantityOnHand} on hand',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: lowStock ? Colors.red : null,
            ),
          ),
          if (lowStock)
            const Text('Below reorder level', style: TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          Text('Cost price R${item.costPrice.toStringAsFixed(2)}'),
          Text('Sell price R${item.sellPrice.toStringAsFixed(2)}'),
          Text('Reorder level: ${item.reorderLevel}'),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add stock'),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _StockAdjustDialog(item: item, type: MovementType.stockIn),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.remove),
                  label: const Text('Use / remove'),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _StockAdjustDialog(item: item, type: MovementType.stockOut),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockAdjustDialog extends ConsumerStatefulWidget {
  const _StockAdjustDialog({required this.item, required this.type});

  final StockItem item;
  final MovementType type;

  @override
  ConsumerState<_StockAdjustDialog> createState() => _StockAdjustDialogState();
}

class _StockAdjustDialogState extends ConsumerState<_StockAdjustDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quanityController = TextEditingController();
  late final _costController =
      TextEditingController(text: widget.item.costPrice.toStringAsFixed(2));
  final _referenceController = TextEditingController();
  bool _saving = false;

  bool get _isStockIn => widget.type == MovementType.stockIn;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isStockIn ? 'Add stock' : 'Remove stock'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _quanityController,
              autofocus: true,
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Enter a whole number greater than 0';
                if (!_isStockIn && n > widget.item.quantityOnHand) {
                  return 'Only ${widget.item.quantityOnHand} on hand';
                }
                return null;
              },
            ),
            if (_isStockIn)
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost price paid (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v != null && v.isNotEmpty && double.tryParse(v) == null)
                    ? 'Enter a number'
                    : null,
              ),
            TextFormField(
              controller: _referenceController,
              decoration: InputDecoration(
                labelText:
                    _isStockIn ? 'PO / invoice number (optional)' : 'Job / reference (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Confirm'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final quantity = int.parse(_quanityController.text);
    final enteredCost = double.tryParse(_costController.text);
    final costAtTime = _isStockIn ? (enteredCost ?? widget.item.costPrice) : widget.item.costPrice;
    final costChanged = _isStockIn && enteredCost != null && enteredCost != widget.item.costPrice;

    try {
      await ref.read(stockMovementServiceProvider).recordMovement(
            itemId: widget.item.id,
            type: widget.type,
            quantity: quantity,
            costAtTime: costAtTime,
            reference:
                _referenceController.text.trim().isEmpty ? null : _referenceController.text.trim(),
            newCostPrice: costChanged ? enteredCost : null,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    }
  }
}