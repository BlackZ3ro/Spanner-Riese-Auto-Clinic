import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../models/booking_status.dart';
import '../models/vehicle_booking.dart';
import '../providers/vehicle_booking_provider.dart';
import 'book_in_screen.dart';
import 'booking_detail_screen.dart';
import 'widgets/phase_widgets.dart';

class BookingsListScreen extends ConsumerStatefulWidget {
  const BookingsListScreen({super.key});

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _query = '';
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tab order: Open (left) / Completed (right), Open shown by default.
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(vehicleBookingProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Checked-in vehicles',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  style: AppText.body(14),
                  decoration: AppTheme.inputDecoration(
                    hint: 'Search by invoice number',
                    fill: AppColors.bg,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.gold,
                  indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.textFaint,
                  labelStyle: AppText.heading(14, weight: FontWeight.w700),
                  unselectedLabelStyle: AppText.heading(14, weight: FontWeight.w700),
                  tabs: const [
                    Tab(text: 'Open'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Text(
                'No vehicles booked in yet.',
                style: AppText.body(14, color: AppColors.textMuted),
              ),
            );
          }

          final filtered = _query.trim().isEmpty
              ? bookings
              : bookings
                  .where((b) =>
                      b.invoiceNumber.toLowerCase().contains(_query.trim().toLowerCase()))
                  .toList();

          final closed = filtered.where((b) => b.status == BookingStatus.closed).toList();
          final open = filtered.where((b) => b.status == BookingStatus.checkedIn).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _BookingListView(bookings: open, emptyMessage: 'No open bookings.'),
              _BookingListView(bookings: closed, emptyMessage: 'No completed bookings.'),
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

class _BookingListView extends StatelessWidget {
  const _BookingListView({required this.bookings, required this.emptyMessage});

  final List<VehicleBooking> bookings;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: AppText.body(14, color: AppColors.textMuted)),
      );
    }
    return ListView.separated(
      // Bottom padding keeps the last card clear of the + button.
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) => _BookingTile(booking: bookings[index]),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});

  final VehicleBooking booking;

  @override
  Widget build(BuildContext context) {
    final url = booking.imageUrl;
    const fallbackIcon = IconChip(
      icon: Icons.directions_car_outlined,
      tone: AppTone.green,
      size: 52,
      iconSize: 24,
      radius: 10,
    );

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookingDetailScreen(bookingId: booking.id)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (url != null && url.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallbackIcon,
              ),
            )
          else
            fallbackIcon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking.brand} ${booking.model} (${booking.year})',
                  style: AppText.heading(15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  '${booking.registration} \u00b7 ${booking.kilometers} km',
                  style: AppText.body(12.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 3),
                Text(
                  'Invoice: ${booking.invoiceNumber}',
                  style: AppText.body(12.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 7),
                StatusPill(label: booking.phase.shortLabel, tone: booking.phase.tone),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.chevron_right, size: 20, color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }
}
