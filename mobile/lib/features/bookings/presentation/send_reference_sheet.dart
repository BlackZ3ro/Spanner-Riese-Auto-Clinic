import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/phone_number.dart';
import '../../../core/widgets/app_widgets.dart';
import '../data/reference_code_messenger.dart';
import '../models/vehicle_booking.dart';

/// Bottom sheet that shows the customer's number and the message, and opens
/// WhatsApp or SMS with it ready to send. Completes when the sheet is closed.
Future<void> showSendReferenceSheet(
  BuildContext context,
  VehicleBooking booking, {
  bool justBooked = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _SendReferenceSheet(booking: booking, justBooked: justBooked),
  );
}

class _SendReferenceSheet extends StatefulWidget {
  const _SendReferenceSheet({required this.booking, required this.justBooked});

  final VehicleBooking booking;
  final bool justBooked;

  @override
  State<_SendReferenceSheet> createState() => _SendReferenceSheetState();
}

class _SendReferenceSheetState extends State<_SendReferenceSheet> {
  String? _notice;
  bool _noticeIsError = false;

  // WhatsApp formatting marks (```) are for WhatsApp only; hide them in the preview and copies.
  String get _plainMessage =>
      ReferenceCodeMessenger.whatsappMessage(widget.booking).replaceAll('```', '');

  void _show(String text, {bool error = false}) {
    if (!mounted) return;
    setState(() {
      _notice = text;
      _noticeIsError = error;
    });
  }

  Future<void> _openWhatsApp() async {
    final ok = await ReferenceCodeMessenger.openWhatsApp(widget.booking);
    if (!ok) _show('Could not open WhatsApp. Check that it is installed.', error: true);
  }

  Future<void> _openSms() async {
    final ok = await ReferenceCodeMessenger.openSms(widget.booking);
    if (!ok) _show('Could not open the SMS app.', error: true);
  }

  Future<void> _copy(String text, String confirmation) async {
    await Clipboard.setData(ClipboardData(text: text));
    _show(confirmation);
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final numberOk = PhoneNumber.international(booking.customerPhone) != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.justBooked ? 'Booking saved' : 'Send reference code',
            style: AppText.heading(18),
          ),
          const SizedBox(height: 4),
          Text(
            widget.justBooked
                ? 'Send the customer their reference code now. You tap Send in WhatsApp or SMS.'
                : 'Opens WhatsApp or SMS with the message ready. You tap Send.',
            style: AppText.body(13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          AppCard(
            radius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const IconChip(
                  icon: Icons.person_outline,
                  tone: AppTone.gold,
                  size: 40,
                  iconSize: 20,
                  radius: 10,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName.isEmpty ? 'Customer' : booking.customerName,
                        style: AppText.body(14, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.customerPhone,
                        style: AppText.body(13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!numberOk) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTone.orange.chipBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18, color: AppTone.orange.chipText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "This number doesn't look right, so WhatsApp and SMS are switched off. "
                      'Check it on the booking, or copy the message and send it yourself.',
                      style: AppText.body(12.5, color: AppTone.orange.chipText),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          AppCard(
            radius: 12,
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('Reference code'),
                      const SizedBox(height: 4),
                      Text(
                        booking.referenceCode,
                        style: AppText.heading(26, color: AppColors.gold, letterSpacing: 3),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Copy code',
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: AppColors.textMuted,
                  onPressed: () => _copy(booking.referenceCode, 'Code copied.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionLabel('Message preview'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_plainMessage, style: AppText.body(13, height: 1.4)),
          ),
          if (_notice != null) ...[
            const SizedBox(height: 12),
            Text(
              _notice!,
              style: AppText.body(
                13,
                weight: FontWeight.w600,
                color: _noticeIsError ? AppColors.danger : AppTone.green.chipText,
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Send on WhatsApp'),
            onPressed: numberOk ? _openWhatsApp : null,
          ),
          // Computers have no SMS app, so SMS is offered on phones only.
          if (!kIsWeb) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.sms_outlined, size: 18),
              label: const Text('Send as SMS'),
              onPressed: numberOk ? _openSms : null,
            ),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => _copy(_plainMessage, 'Message copied.'),
                child: const Text('Copy message'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
