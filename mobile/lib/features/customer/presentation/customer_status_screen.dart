import 'package:flutter/material.dart';
import '../models/customer_booking_view.dart';
import '../../bookings/models/booking_phase.dart';

class CustomerStatusScreen extends StatelessWidget{
  const CustomerStatusScreen({super.key, required this.booking});
  final CustomerBookingView booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle status')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (booking.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(booking.imageUrl!, height: 160, fit: BoxFit.cover,),
            ),
          const SizedBox(height: 12,),
           Text('${booking.brand} ${booking.model} (${booking.year})',
              style: Theme.of(context).textTheme.headlineSmall),
          Text('Registration: ${booking.registration}'),
          Text('Reference: ${booking.referenceCode}'),
          const Divider(height: 32),
          Text('Progress', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildPhaseStepper(booking.phase),
          const Divider(height: 32),
          Text('Parts used so far', style: Theme.of(context).textTheme.titleMedium),
          if (booking.parts.isEmpty)
            const Text('None logged yet.')
          else
            for (final part in booking.parts)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(part.name),
                trailing: Text('× ${part.quantity}'),
              ),
          const Divider(height: 32),
          Text('Work done so far', style: Theme.of(context).textTheme.titleMedium),
          if (booking.labor.isEmpty)
            const Text('None logged yet.')
          else
            for (final item in booking.labor)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.description),
                trailing: Text('${item.hours} hrs'),
              ),
        ],
      ),
    );
  }

  Widget _buildPhaseStepper(BookingPhase currentPhase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final phase in BookingPhase.values)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              phase.stepNumber <= currentPhase.stepNumber
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: phase.stepNumber <= currentPhase.stepNumber ? Colors.green : Colors.grey,
            ),
            title: Text(
              phase.displayName,
              style: phase == currentPhase ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
          ),
      ],
    );
  }
}