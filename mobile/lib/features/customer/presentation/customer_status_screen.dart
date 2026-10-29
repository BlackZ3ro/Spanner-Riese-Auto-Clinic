import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../bookings/models/booking_phase.dart';
import '../../bookings/presentation/widgets/phase_widgets.dart';
import '../models/customer_booking_view.dart';
import '../providers/customer_booking_provider.dart';

class CustomerStatusScreen extends ConsumerStatefulWidget {
  const CustomerStatusScreen({
    super.key,
    required this.referenceCode,
    this.initialBooking,
  });

  final String referenceCode;
  final CustomerBookingView? initialBooking;

  @override
  ConsumerState<CustomerStatusScreen> createState() => _CustomerStatusScreenState();
}

class _CustomerStatusScreenState extends ConsumerState<CustomerStatusScreen> {
  CustomerBookingView? _booking;
  bool _loading = true;
  bool _notFound = false;
  String? _error;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _booking = widget.initialBooking;
    _loading = widget.initialBooking == null;
    _subscribe();
    if (widget.initialBooking == null) _refresh();
  }

  @override
  void dispose() {
    final channel = _channel;
    if (channel != null) {
      Supabase.instance.client.removeChannel(channel);
    }
    super.dispose();
  }

  void _subscribe() {
    final code = widget.referenceCode.trim().toUpperCase();
    _channel = Supabase.instance.client
        .channel('booking:$code')
        .onBroadcast(event: 'booking_updated', callback: (_) => _refresh())
        .subscribe((status, error) {
      // Catches anything that changed between the first load and going live.
      if (status == RealtimeSubscribeStatus.subscribed) _refresh();
    });
  }

  Future<void> _refresh() async {
    try {
      final view = await ref
          .read(customerBookingRepositoryProvider)
          .lookupByReferenceCode(widget.referenceCode);
      if (!mounted) return;
      setState(() {
        _booking = view;
        _notFound = view == null;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        // If we already have data on screen, keep showing it rather than an error.
        if (_booking == null) _error = 'Could not load this booking.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Vehicle status'),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final booking = _booking;
    if (booking == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _notFound
                    ? 'This booking is no longer available.'
                    : (_error ?? 'Something went wrong.'),
                textAlign: TextAlign.center,
                style: AppText.body(14, color: AppColors.textMuted),
              ),
              if (!_notFound) ...[
                const SizedBox(height: 16),
                FilledButton(onPressed: _refresh, child: const Text('Try again')),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.gold,
      backgroundColor: AppColors.surface,
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          VehiclePhoto(imageUrl: booking.imageUrl, height: 130),
          const SizedBox(height: 14),
          Text(
            '${booking.brand} ${booking.model} (${booking.year})',
            style: AppText.heading(21),
          ),
          const SizedBox(height: 4),
          Text(
            'Registration: ${booking.registration}',
            style: AppText.body(13.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            'Reference: ${booking.referenceCode}',
            style: AppText.body(13.5, color: AppColors.textMuted),
          ),
          const AppDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppText.heading(16, weight: FontWeight.w700)),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Updates automatically',
                    style: AppText.body(11.5, color: AppColors.textFaint),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (booking.phase == BookingPhase.finalized) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: StatusPill(
                label: 'Finalized \u2014 booked out to customer',
                tone: AppTone.green,
                large: true,
              ),
            ),
            const SizedBox(height: 6),
          ],
          PhaseTimeline(phase: booking.phase),
          const AppDivider(),
          Text('Parts used so far', style: AppText.heading(15, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (booking.parts.isEmpty)
            Text('None logged yet.', style: AppText.body(13.5, color: AppColors.textMuted))
          else
            for (final part in booking.parts)
              _SimpleRow(left: part.name, right: '\u00d7 ${part.quantity}'),
          const AppDivider(),
          Text('Work done so far', style: AppText.heading(15, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (booking.labor.isEmpty)
            Text('None logged yet.', style: AppText.body(13.5, color: AppColors.textMuted))
          else
            for (final item in booking.labor)
              _SimpleRow(left: item.description, right: '${_hours(item.hours)} hrs'),
        ],
      ),
    );
  }

  String _hours(double hours) =>
      hours == hours.roundToDouble() ? hours.toStringAsFixed(0) : hours.toString();
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(left, style: AppText.body(13.5))),
          const SizedBox(width: 12),
          Text(right, style: AppText.body(13, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
