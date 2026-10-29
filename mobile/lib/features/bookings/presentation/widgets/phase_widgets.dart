import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/booking_phase.dart';

/// Short labels and colours for each phase, as used in the designs:
/// gold = just booked in, orange = work under way, green = finished.
extension BookingPhaseStyle on BookingPhase {
  String get shortLabel => switch (this) {
        BookingPhase.bookedIn => 'Book-in & inspection',
        BookingPhase.laborInProgress => 'Labor in progress',
        BookingPhase.reassembly => 'Reassembly',
        BookingPhase.readyForPickup => 'Ready for pickup',
        BookingPhase.finalized => 'Finalized',
      };

  String get timelineLabel =>
      this == BookingPhase.readyForPickup ? 'Finished \u2014 ready for pickup' : shortLabel;

  AppTone get tone => switch (this) {
        BookingPhase.bookedIn => AppTone.gold,
        BookingPhase.laborInProgress => AppTone.orange,
        BookingPhase.reassembly => AppTone.orange,
        BookingPhase.readyForPickup => AppTone.green,
        BookingPhase.finalized => AppTone.green,
      };
}

enum _StepState { done, active, upcoming }

/// The four steps people see. "Finalized" is set automatically when a booking
/// is closed, so it is not a step of its own: it just completes all four.
_StepState _stateFor(BookingPhase phase, int index) {
  final steps = BookingPhase.selectable;
  final complete = phase == BookingPhase.readyForPickup || phase == BookingPhase.finalized;
  final current = steps.indexOf(phase);
  if (complete || index < current) return _StepState.done;
  if (index == current) return _StepState.active;
  return _StepState.upcoming;
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.index, required this.state, required this.numbered});

  final int index;
  final _StepState state;

  /// Horizontal stepper shows numbers; the vertical timeline shows ticks.
  final bool numbered;

  static const double _size = 26;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _StepState.done:
        return _filled(AppColors.green, const Icon(Icons.check, size: 15, color: Colors.white));
      case _StepState.active:
        return _filled(
          AppColors.orange,
          numbered
              ? Text('${index + 1}', style: AppText.heading(12, color: Colors.white))
              : const Icon(Icons.check, size: 15, color: Colors.white),
        );
      case _StepState.upcoming:
        return Container(
          width: _size,
          height: _size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline, width: 2),
          ),
          child: numbered
              ? Text('${index + 1}', style: AppText.heading(12, color: AppColors.textFaint))
              : null,
        );
    }
  }

  Widget _filled(Color color, Widget child) => Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: child,
      );
}

/// Horizontal four-step tracker for staff. When [onSelect] is given, tapping
/// a step asks to move the booking to that phase.
class PhaseStepper extends StatelessWidget {
  const PhaseStepper({super.key, required this.phase, this.onSelect});

  final BookingPhase phase;
  final ValueChanged<BookingPhase>? onSelect;

  static const _labels = {
    BookingPhase.bookedIn: 'Book-in &\ninspection',
    BookingPhase.laborInProgress: 'Labor in\nprogress',
    BookingPhase.reassembly: 'Reassembly',
    BookingPhase.readyForPickup: 'Ready for\npickup',
  };

  @override
  Widget build(BuildContext context) {
    final steps = BookingPhase.selectable;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _Step(
              index: i,
              state: _stateFor(phase, i),
              label: _labels[steps[i]] ?? steps[i].shortLabel,
              onTap: (onSelect != null && steps[i] != phase) ? () => onSelect!(steps[i]) : null,
            ),
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 2,
                  color: _stateFor(phase, i + 1) == _StepState.upcoming
                      ? AppColors.border
                      : AppColors.green,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.state, required this.label, this.onTap});

  final int index;
  final _StepState state;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final active = state == _StepState.active;
    final color = active
        ? AppColors.text
        : state == _StepState.done
            ? AppColors.textMuted
            : AppColors.textFaint;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepCircle(index: index, state: state, numbered: true),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppText.body(
              10.5,
              weight: active ? FontWeight.w700 : FontWeight.w400,
              color: color,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical read-only timeline for customers.
class PhaseTimeline extends StatelessWidget {
  const PhaseTimeline({super.key, required this.phase});

  final BookingPhase phase;

  @override
  Widget build(BuildContext context) {
    final steps = BookingPhase.selectable;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                _StepCircle(index: i, state: _stateFor(phase, i), numbered: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    steps[i].timelineLabel,
                    style: AppText.body(
                      14.5,
                      weight: _stateFor(phase, i) == _StepState.active
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: switch (_stateFor(phase, i)) {
                        _StepState.active => AppColors.text,
                        _StepState.done => AppColors.textMuted,
                        _StepState.upcoming => AppColors.textFaint,
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
