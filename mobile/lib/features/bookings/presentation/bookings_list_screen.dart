import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_status.dart';
import '../models/vehicle_booking.dart';
import '../providers/vehicle_booking_provider.dart';
import 'book_in_screen.dart';
import 'booking_detail_screen.dart';

class BookingsListScreen extends ConsumerStatefulWidget {
  const BookingsListScreen({super.key});

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(vehicleBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checked-in vehicles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by invoice number',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
        ),
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No vehicles booked in yet.'));
          }

          final filtered = _query.trim().isEmpty
              ? bookings
              : bookings
                  .where((b) =>
                      b.invoiceNumber.toLowerCase().contains(_query.trim().toLowerCase()))
                  .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No bookings match that invoice number.'));
          }

          final checkedIn = filtered.where((b) => b.status == BookingStatus.checkedIn).toList();
          final closed = filtered.where((b) => b.status == BookingStatus.closed).toList();

          return ListView(
            children: [
              if (checkedIn.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Checked in', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                for (final booking in checkedIn) _BookingTile(booking: booking),
              ],
              if (closed.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Closed', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                for (final booking in closed) _BookingTile(booking: booking),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookInScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});
  final VehicleBooking booking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: booking.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(booking.imageUrl!, width: 56, height: 56, fit: BoxFit.cover),
            )
          : const Icon(Icons.directions_car, size: 40),
      title: Text('${booking.brand} ${booking.model} (${booking.year})'),
      subtitle: Text(
        '${booking.registration} • ${booking.kilometers} km\nInvoice: ${booking.invoiceNumber}',
      ),
      isThreeLine: true,
      trailing: booking.status == BookingStatus.closed
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookingDetailScreen(bookingId: booking.id)),
      ),
    );
  }
}