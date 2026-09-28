import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stock/models/stock_item.dart';
import '../../stock/providers/stock_item_provider.dart';
import '../models/booking_labor.dart';
import '../models/booking_part.dart';
import '../models/booking_status.dart';
import '../models/vehicle_booking.dart';
import '../providers/booking_labor_provider.dart';
import '../providers/booking_part_service.dart';
import '../providers/booking_parts_provider.dart';
import '../providers/invoice_pdf_provider.dart';
import '../providers/vehicle_booking_provider.dart';
import 'package:intl/intl.dart';
import '../../auth/models/user_role.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/booking_deletion_service.dart';
import '../models/booking_phase.dart';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(vehicleBookingProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final isAdmin = profileAsync.value?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking details')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookings) {
          final booking = bookings.firstWhere((b) => b.id == bookingId);
          return _buildBody(context, ref, booking, isAdmin);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, VehicleBooking booking, bool isAdmin) {
    final partsAsync = ref.watch(bookingPartsProvider(booking.id));
    final laborAsync = ref.watch(bookingLaborProvider(booking.id));
    final stockItems = ref.watch(stockItemProvider).value ?? <StockItem>[];
    final isOpen = booking.status == BookingStatus.checkedIn;
    final parts = partsAsync.value ?? <BookingPart>[];
    final labor = laborAsync.value ?? <BookingLabor>[];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (booking.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(booking.imageUrl!, height: 160, fit: BoxFit.cover),
          ),
        const SizedBox(height: 12),
        Text('${booking.brand} ${booking.model} (${booking.year})',
            style: Theme.of(context).textTheme.headlineSmall),
        Text('Invoice: ${booking.invoiceNumber}',
          style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold)),
        Text('Reference: ${booking.referenceCode}'),
        if (booking.customerName.isNotEmpty) ...[
          const SizedBox(height: 8,),
          Text('Customer', style: Theme.of(context).textTheme.titleSmall,),
          Text(booking.customerName),
          Text(booking.customerPhone),
          if (booking.customerEmail != null) Text(booking.customerEmail!),
          if (booking.customerCompany != null) Text(booking.customerCompany!), 
        ],
        const SizedBox(height: 4,),
        Text('Registration: ${booking.registration}'),
        Text('Kilometers: ${booking.kilometers} km'),
        if (booking.engineSize != null) Text('Engine size: ${booking.engineSize}'),
        if (booking.engineCode != null) Text('Engine code: ${booking.engineCode}'),
        Text('Transmission: ${booking.transmissionType.displayName}'),
        const SizedBox(height: 8),
        Chip(
          label: Text(booking.status.displayName),
          backgroundColor: isOpen ? Colors.orange[100] : Colors.green[100],
        ),
        const SizedBox(height: 8,),
        Text('Booked in: ${_formatDateTime(booking.createdAt)}'),
        if (booking.closedAt != null)
          Text('Finalized: ${_formatDateTime(booking.closedAt)}'),
        const Divider(height: 32),
        const SizedBox(height: 12),
Text('Phase', style: Theme.of(context).textTheme.titleSmall),
if (isOpen)
  DropdownButton<BookingPhase>(
    value: booking.phase,
    isExpanded: true,
    items: BookingPhase.selectable
        .map((p) => DropdownMenuItem(value: p, child: Text(p.displayName)))
        .toList(),
    onChanged: (newPhase) async {
      if (newPhase == null) return;
      try {
        await ref.read(vehicleBookingProvider.notifier).updatePhase(booking.id, newPhase);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Could not update phase: $e')));
        }
      }
    },
  )
else
  Text(booking.phase.displayName),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Parts', style: Theme.of(context).textTheme.titleMedium),
            if (isOpen)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => _AddPartDialog(booking: booking, stockItems: stockItems),
                ),
              ),
          ],
        ),
        if (parts.isEmpty)
          const Text('No parts allocated yet.')
        else
          for (final part in parts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                stockItems
                    .firstWhere((i) => i.id == part.stockItemId, orElse: () => stockItems.first)
                    .name,
              ),
              subtitle: Text('${part.quantity} × R ${part.unitPrice.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('R ${(part.unitPrice * part.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isOpen)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _confirmRemovePart(context, ref, booking, part, stockItems),
                  )
                ],
              )
            ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Labor / work done', style: Theme.of(context).textTheme.titleMedium),
            if (isOpen)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => _AddLaborDialog(bookingId: booking.id),
                ),
              ),
          ],
        ),
        if (labor.isEmpty)
          const Text('No work logged yet.')
        else
          for (final item in labor)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.description),
              subtitle: Text('${item.hours} hrs * R${item.rate.toStringAsFixed(2)}'),
              trailing: Row( 
              mainAxisSize: MainAxisSize.min,
              children: [
               Text('R ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isOpen)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _confirmRemoveLabor(context, ref, booking.id, item),
                  ),
              ],
              ),
            ),
        const Divider(height: 32),
        _buildTotals(parts, labor),
        const SizedBox(height: 24),
        if (isOpen && isAdmin) ...[
          FilledButton.icon(
            icon: const Icon(Icons.lock_outline),
            label: const Text('Finalize & close'),
            onPressed: () => _confirmClose(context, ref, booking),
          ),
          const SizedBox(height: 12,),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete booking'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => _confirmDeleteBooking(context, ref, booking), 
          ),
          const SizedBox(height: 12,)
        ],
        if (!isOpen && isAdmin) ...[
          OutlinedButton.icon(
            icon: const Icon(Icons.lock_open),
            label: const Text('Reopen booking'),
            onPressed: () => _confirmReopen(context, ref, booking),
          ),
  const SizedBox(height: 12),
],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Export / print invoice'),
          onPressed: () async {
            final names = {for (final item in stockItems) item.id: item.name};
            await ref.read(invoicePdfServiceProvider).printOrShare(
                  booking: booking,
                  parts: parts,
                  labor: labor,
                  stockItemNames: names,
                );
          },
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime){
    if (dateTime == null) return 'Unknown';
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime.toLocal());
  }

  Widget _buildTotals(List<BookingPart> parts, List<BookingLabor> labor) {
    final partsTotal = parts.fold<double>(0, (sum, p) => sum + (p.unitPrice * p.quantity));
    final laborTotal = labor.fold<double>(0, (sum, l) => sum + l.price);
    final grandTotal = partsTotal + laborTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Parts total: R ${partsTotal.toStringAsFixed(2)}'),
        Text('Labor total: R ${laborTotal.toStringAsFixed(2)}'),
        const SizedBox(height: 4),
        Text('Grand total: R ${grandTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _confirmDeleteBooking(BuildContext context, WidgetRef ref, VehicleBooking booking) {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title:  const Text('Delete this booking?'),
        content: const Text(
          'This permanently removes the booking and returns any allocated parts to the stock. This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(), 
              child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await ref.read(bookingDeletionServiceProvider).deleteBooking(booking);
                  if (context.mounted) Navigator.of(context).pop();
                }, 
                child: const Text('Delete'),
                )
          ],
      ) 
      );
  }

  void _confirmClose(BuildContext context, WidgetRef ref, VehicleBooking booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalize booking?'),
        content: const Text(
            'This closes the job. Parts and labor can no longer be added after this.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(vehicleBookingProvider.notifier).closeBooking(booking.id);
            },
            child: const Text('Finalize'),
          ),
        ],
      ),
    );
  }


void _confirmRemovePart(
  BuildContext context,
  WidgetRef ref,
  VehicleBooking booking,
  BookingPart part,
  List<StockItem> stockItems,
) {
  showDialog(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      title: const Text('Remove part?'),
      content: const Text('This will also add the quantity back to stock.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), 
        child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            final item = stockItems.firstWhere(
              (i) => i.id == part.stockItemId,
              orElse: () => stockItems.first,
            );
            await ref.read(bookingPartServiceProvider).removePart(
              partId: part.id, 
              stockItemId: part.stockItemId, 
              quantity: part.quantity, 
              costPrice: item.costPrice, 
              registration: booking.registration
              );
              ref.invalidate(bookingPartsProvider(booking.id));
          }, 
          child: const Text('Remove'),
        ), 
      ],
    ),
  );
}

void _confirmRemoveLabor(
  BuildContext context,
  WidgetRef ref,
  String bookingId,
  BookingLabor item,
){
  showDialog(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      title: const Text('Remove this work item?'),
      content: Text('"${item.description}" will be removed from this booking.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(), 
          child: const Text('Cancel')
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(bookingLaborProvider(bookingId).notifier).removeLabor(item.id);
            }, 
            child: const Text('Remove')
            )
      ],
    )
    );
  }

  void _confirmReopen(BuildContext context, WidgetRef ref, VehicleBooking booking) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Reopen this booking?'),
      content: const Text(
          'This resumes work on the booking — parts and labor can be added again, and the finalized date will be cleared until it\'s closed next time.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await ref.read(vehicleBookingProvider.notifier).reopenBooking(booking.id);
          },
          child: const Text('Reopen'),
        ),
      ],
    ),
  );
}
}

class _AddPartDialog extends ConsumerStatefulWidget {
  const _AddPartDialog({required this.booking, required this.stockItems});
  final VehicleBooking booking;
  final List<StockItem> stockItems;

  @override
  ConsumerState<_AddPartDialog> createState() => _AddPartDialogState();
}

class _AddPartDialogState extends ConsumerState<_AddPartDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  StockItem? _selectedItem;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add part'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<StockItem>(
              decoration: const InputDecoration(labelText: 'Stock item'),
              initialValue: _selectedItem,
              items: widget.stockItems
                  .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                  .toList(),
              onChanged: (item) {
                setState(() {
                  _selectedItem = item;
                  _priceController.text = item?.sellPrice.toStringAsFixed(2) ?? '';
                });
              },
              validator: (v) => v == null ? 'Pick an item' : null,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Enter a whole number greater than 0';
                if (_selectedItem != null && n > _selectedItem!.quantityOnHand) {
                  return 'Only ${_selectedItem!.quantityOnHand} on hand';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price charged (per unit)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) =>
                  (v == null || double.tryParse(v) == null) ? 'Enter a number' : null,
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
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      await ref.read(bookingPartServiceProvider).allocatePart(
            bookingId: widget.booking.id,
            stockItemId: _selectedItem!.id,
            quantity: int.parse(_quantityController.text),
            customerPrice: double.parse(_priceController.text),
            costPrice: _selectedItem!.costPrice,
            registration: widget.booking.registration,
          );
      ref.invalidate(bookingPartsProvider(widget.booking.id));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not add part: $e')));
      }
    }
  }
}

class _AddLaborDialog extends ConsumerStatefulWidget {
  const _AddLaborDialog({required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<_AddLaborDialog> createState() => _AddLaborDialogState();
}

class _AddLaborDialogState extends ConsumerState<_AddLaborDialog> {
  static const double _defaultRate = 350;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _hoursController = TextEditingController();
  final _rateController = TextEditingController(text: _defaultRate.toStringAsFixed(2));
  bool _saving = false;

  double get _hours => double.tryParse(_hoursController.text) ?? 0;
  double get _rate => double.tryParse(_rateController.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add work / labor'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _hoursController,
              decoration: const InputDecoration(labelText: 'Hours'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if(n == null || n <= 0) return 'Enter a number greater than 0';
                return null;
              },
            ),
            TextFormField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Rate per hour',
                helperText: 'Standard rate is R350 - adjust if needed',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                (v == null || double.tryParse(v) == null) ? 'Enter a number' : null,
            )
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
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      await ref.read(bookingLaborProvider(widget.bookingId).notifier).addLabor(
            description: _descriptionController.text.trim(),
            hours: _hours,
            rate: _rate,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add: $e')));
      }
    }
  }
}