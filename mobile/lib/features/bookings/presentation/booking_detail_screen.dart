import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/models/user_role.dart';
import '../../auth/providers/auth_provider.dart';
import '../../stock/models/stock_item.dart';
import '../../stock/providers/stock_item_provider.dart';
import '../models/booking_labor.dart';
import '../models/booking_part.dart';
import '../models/booking_phase.dart';
import '../models/booking_status.dart';
import '../models/vehicle_booking.dart';
import '../providers/booking_deletion_service.dart';
import '../providers/booking_labor_provider.dart';
import '../providers/booking_part_service.dart';
import '../providers/booking_parts_provider.dart';
import '../providers/invoice_pdf_provider.dart';
import '../providers/vehicle_booking_provider.dart';
import 'widgets/phase_widgets.dart';
import 'send_reference_sheet.dart';

String _formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return 'Unknown';
  return DateFormat('dd MMM yyyy, HH:mm').format(dateTime.toLocal());
}

String _money(double amount) => 'R${amount.toStringAsFixed(2)}';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(vehicleBookingProvider);
    final isAdmin = ref.watch(currentProfileProvider).value?.role == UserRole.admin;

    return Scaffold(
      appBar: const AppTopBar(title: 'Booking details'),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookings) {
          final matches = bookings.where((b) => b.id == bookingId);
          if (matches.isEmpty) {
            return Center(
              child: Text(
                'This booking is no longer available.',
                style: AppText.body(14, color: AppColors.textMuted),
              ),
            );
          }
          return _buildBody(context, ref, matches.first, isAdmin);
        },
      ),
    );
  }

  String _stockItemName(List<StockItem> items, String id) {
    final match = items.where((i) => i.id == id);
    return match.isEmpty ? 'Unknown item' : match.first.name;
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, VehicleBooking booking, bool isAdmin) {
    final partsAsync = ref.watch(bookingPartsProvider(booking.id));
    final laborAsync = ref.watch(bookingLaborProvider(booking.id));
    final stockItems = ref.watch(stockItemProvider).value ?? <StockItem>[];
    final isOpen = booking.status == BookingStatus.checkedIn;
    final parts = partsAsync.value ?? <BookingPart>[];
    final labor = laborAsync.value ?? <BookingLabor>[];

    final partsTotal = parts.fold<double>(0, (sum, p) => sum + (p.unitPrice * p.quantity));
    final laborTotal = labor.fold<double>(0, (sum, l) => sum + l.price);

    return RefreshIndicator(
      // Pull down to reload this booking, its parts and its labour from Supabase.
      onRefresh: () async {
        ref.invalidate(bookingPartsProvider(booking.id));
        ref.invalidate(bookingLaborProvider(booking.id));
        ref.invalidate(stockItemProvider);
        ref.invalidate(vehicleBookingProvider);
        await ref.read(vehicleBookingProvider.future);
      },
      child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        VehiclePhoto(imageUrl: booking.imageUrl),
        const SizedBox(height: 14),
        Text('${booking.brand} ${booking.model} (${booking.year})', style: AppText.heading(20)),
        const SizedBox(height: 4),
        Text(
          'Invoice: ${booking.invoiceNumber}',
          style: AppText.body(13.5, weight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          'Reference: ${booking.referenceCode}',
          style: AppText.body(13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),
        if (booking.customerName.isNotEmpty) ...[
          _CustomerCard(booking: booking),
          const SizedBox(height: 14),
        ],
        _VehicleFacts(booking: booking),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusPill(
              label: isOpen ? 'Checked in' : 'Closed',
              tone: isOpen ? AppTone.gold : AppTone.green,
              large: true,
            ),
            Text(
              'Booked in: ${_formatDateTime(booking.createdAt)}',
              style: AppText.body(12.5, color: AppColors.textFaint),
            ),
          ],
        ),
        if (booking.closedAt != null) ...[
          const SizedBox(height: 6),
          Text(
            'Finalized: ${_formatDateTime(booking.closedAt)}',
            style: AppText.body(12.5, color: AppColors.textFaint),
          ),
        ],
        const AppDivider(),
        const SectionLabel('Phase'),
        const SizedBox(height: 14),
        PhaseStepper(
          phase: booking.phase,
          onSelect: isOpen ? (phase) => _confirmPhaseChange(context, ref, booking, phase) : null,
        ),
        if (isOpen) ...[
          const SizedBox(height: 10),
          Text(
            'Tap a step to change the phase. The customer is notified.',
            style: AppText.body(11.5, color: AppColors.textFaint),
          ),
        ],
        const AppDivider(),
        _SectionHeader(
          title: 'Parts',
          onAdd: isOpen
              ? () => showDialog(
                    context: context,
                    builder: (_) => _AddPartDialog(booking: booking, stockItems: stockItems),
                  )
              : null,
        ),
        if (parts.isEmpty)
          Text('No parts allocated yet.', style: AppText.body(13.5, color: AppColors.textMuted))
        else
          for (var i = 0; i < parts.length; i++)
            _LineItem(
              title: _stockItemName(stockItems, parts[i].stockItemId),
              subtitle: '${parts[i].quantity} \u00d7 ${_money(parts[i].unitPrice)}',
              amount: _money(parts[i].unitPrice * parts[i].quantity),
              showDivider: i < parts.length - 1,
              onRemove: isOpen
                  ? () => _confirmRemovePart(context, ref, booking, parts[i], stockItems)
                  : null,
            ),
        const AppDivider(),
        _SectionHeader(
          title: 'Labor / work done',
          onAdd: isOpen
              ? () => showDialog(
                    context: context,
                    builder: (_) => _AddLaborDialog(bookingId: booking.id),
                  )
              : null,
        ),
        if (labor.isEmpty)
          Text('No work logged yet.', style: AppText.body(13.5, color: AppColors.textMuted))
        else
          for (var i = 0; i < labor.length; i++)
            _LineItem(
              title: labor[i].description,
              subtitle: '${labor[i].hours} hrs \u00d7 ${_money(labor[i].rate)}/hr',
              amount: _money(labor[i].price),
              showDivider: i < labor.length - 1,
              onRemove:
                  isOpen ? () => _confirmRemoveLabor(context, ref, booking.id, labor[i]) : null,
            ),
        const AppDivider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Parts total: ${_money(partsTotal)}',
                style: AppText.body(13, color: AppColors.textMuted)),
            const SizedBox(height: 3),
            Text('Labor total: ${_money(laborTotal)}',
                style: AppText.body(13, color: AppColors.textMuted)),
            const SizedBox(height: 5),
            Text('Grand total: ${_money(partsTotal + laborTotal)}', style: AppText.heading(19)),
          ],
        ),
        const SizedBox(height: 20),
        if (isAdmin && isOpen) ...[
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text('Finalize & close'),
            onPressed: () => _confirmClose(context, ref, booking),
          ),
          const SizedBox(height: 12),
        ],
        if (isAdmin && !isOpen) ...[
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.lock_open, size: 18),
            label: const Text('Reopen booking'),
            onPressed: () => _confirmReopen(context, ref, booking),
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
          label: const Text('Export / print invoice'),
          onPressed: () async {
            final names = {for (final item in stockItems) item.id: item.name};
            try {
              await ref.read(invoicePdfServiceProvider).printOrShare(
                    booking: booking,
                    parts: parts,
                    labor: labor,
                    stockItemNames: names,
                  );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Could not create the invoice: $e')));
              }
            }
          },
        ),
        if (isAdmin && isOpen) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.dangerOutline),
            ),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete booking'),
            onPressed: () => _confirmDeleteBooking(context, ref, booking),
          ),
        ],
        const SizedBox(height: 8),
      ],
      ),
    );
  }

  void _confirmPhaseChange(
    BuildContext context,
    WidgetRef ref,
    VehicleBooking booking,
    BookingPhase newPhase,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Move to "${newPhase.shortLabel}"?'),
        content: const Text(
            'If the customer is following this booking in the app, they will get a notification.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(vehicleBookingProvider.notifier).updatePhase(booking.id, newPhase);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not update phase: $e')));
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBooking(BuildContext context, WidgetRef ref, VehicleBooking booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this booking?'),
        content: const Text(
            'This permanently removes the booking and returns any allocated parts to the stock. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.onGold,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(bookingDeletionServiceProvider).deleteBooking(booking);
                if (context.mounted) Navigator.of(context).pop();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not delete booking: $e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
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
              try {
                await ref.read(vehicleBookingProvider.notifier).closeBooking(booking.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not finalize booking: $e')));
                }
              }
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
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final matches = stockItems.where((i) => i.id == part.stockItemId);
              if (matches.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not find this item in stock.')),
                  );
                }
                return;
              }
              try {
                await ref.read(bookingPartServiceProvider).removePart(
                      partId: part.id,
                      stockItemId: part.stockItemId,
                      quantity: part.quantity,
                      costPrice: matches.first.costPrice,
                      registration: booking.registration,
                    );
                ref.invalidate(bookingPartsProvider(booking.id));
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not remove part: $e')));
                }
              }
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
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove this work item?'),
        content: Text('"${item.description}" will be removed from this booking.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(bookingLaborProvider(bookingId).notifier).removeLabor(item.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not remove work item: $e')));
                }
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _confirmReopen(BuildContext context, WidgetRef ref, VehicleBooking booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reopen this booking?'),
        content: const Text(
            'This resumes work on the booking. Parts and labor can be added again, and the finalized date will be cleared until it is closed next time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(vehicleBookingProvider.notifier).reopenBooking(booking.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Could not reopen booking: $e')));
                }
              }
            },
            child: const Text('Reopen'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small building blocks used by the screen above
// ---------------------------------------------------------------------------

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.booking});

  final VehicleBooking booking;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Customer'),
            const SizedBox(height: 4),
            Text(booking.customerName, style: AppText.body(14, weight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(booking.customerPhone, style: AppText.body(13, color: AppColors.textMuted)),
            if (booking.customerEmail != null)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  booking.customerEmail!,
                  style: AppText.body(13, color: AppColors.textMuted),
                ),
              ),
            if (booking.customerCompany != null)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  booking.customerCompany!,
                  style: AppText.body(13, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.send_outlined, size: 16),
              label: const Text('Send reference code'),
              onPressed: () => showSendReferenceSheet(context, booking),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleFacts extends StatelessWidget {
  const _VehicleFacts({required this.booking});

  final VehicleBooking booking;

  Widget _fact(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text.rich(
          TextSpan(
            style: AppText.body(13.5, color: AppColors.textMuted),
            children: [
              TextSpan(text: '$label: '),
              TextSpan(
                text: value,
                style: AppText.body(13.5, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fact('Registration', booking.registration),
        _fact('Kilometers', '${booking.kilometers} km'),
        if (booking.engineSize != null) _fact('Engine size', booking.engineSize!),
        if (booking.engineCode != null) _fact('Engine code', booking.engineCode!),
        _fact('Transmission', booking.transmissionType.displayName),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onAdd});

  final String title;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.heading(15, weight: FontWeight.w700)),
          if (onAdd != null)
            Tooltip(
              message: 'Add',
              child: Material(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onAdd,
                  child: const SizedBox(width: 28, height: 28, child: Icon(Icons.add, size: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.showDivider,
    this.onRemove,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool showDivider;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFF242729)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body(13.5, weight: FontWeight.w500)),
                const SizedBox(height: 1),
                Text(subtitle, style: AppText.body(12, color: AppColors.textFaint)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(amount, style: AppText.body(13.5, weight: FontWeight.w700)),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.close, size: 18, color: AppColors.textFaint),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialogs
// ---------------------------------------------------------------------------

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
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add part'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<StockItem>(
              isExpanded: true,
              decoration: AppTheme.inputDecoration(label: 'Stock item', fill: AppColors.bg),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              decoration: AppTheme.inputDecoration(label: 'Quantity', fill: AppColors.bg),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: AppTheme.inputDecoration(
                label: 'Price charged (per unit)',
                fill: AppColors.bg,
              ),
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
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onGold),
                )
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
      if (mounted) {
        setState(() => _saving = false);
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
  void dispose() {
    _descriptionController.dispose();
    _hoursController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add work / labor'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: AppTheme.inputDecoration(label: 'Description', fill: AppColors.bg),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hoursController,
              decoration: AppTheme.inputDecoration(label: 'Hours', fill: AppColors.bg),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Enter a number greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _rateController,
              decoration: AppTheme.inputDecoration(
                label: 'Rate per hour',
                helper: 'Standard rate is R350 - adjust if needed',
                fill: AppColors.bg,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  (v == null || double.tryParse(v) == null) ? 'Enter a number' : null,
            ),
            const SizedBox(height: 12),
            Text('Total: ${_money(_hours * _rate)}', style: AppText.body(14, weight: FontWeight.w700)),
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
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onGold),
                )
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
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add: $e')));
      }
    }
  }
}
