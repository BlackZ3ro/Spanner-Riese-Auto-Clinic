import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/models/booking_status.dart';
import '../../bookings/presentation/bookings_list_screen.dart';
import '../../bookings/providers/vehicle_booking_provider.dart';
import '../../stock/presentation/stock_list_screen.dart';
import '../../stock/providers/stock_item_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final bookings = ref.watch(vehicleBookingProvider).value;
    final stock = ref.watch(stockItemProvider).value;

    final openJobs = bookings?.where((b) => b.status == BookingStatus.checkedIn).length;
    final lowStock = stock?.where((i) => i.quantityOnHand <= i.reorderLevel).length;

    final roleLabel = profileAsync.when(
      data: (profile) => profile?.role.displayName ?? 'Signed in',
      loading: () => '...',
      error: (_, _) => 'Signed in',
    );

    return Scaffold(
      appBar: AppTopBar(
        title: 'Riese Auto Clinic',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            tooltip: 'Sign out',
            color: AppColors.textMuted,
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            child: Row(
              children: [
                const IconChip(icon: Icons.person_outline, tone: AppTone.gold),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Signed in as'),
                    const SizedBox(height: 2),
                    Text(roleLabel, style: AppText.heading(17, weight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: openJobs?.toString() ?? '-',
                  label: openJobs == 1 ? 'Open job' : 'Open jobs',
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const BookingsListScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: lowStock?.toString() ?? '-',
                  label: lowStock == 1 ? 'Low stock item' : 'Low stock items',
                  valueColor: (lowStock ?? 0) > 0 ? AppTone.orange.chipText : AppColors.text,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const StockListScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionLabel('Workspace'),
          const SizedBox(height: 18),
          _MenuCard(
            icon: Icons.directions_car_outlined,
            tone: AppTone.green,
            title: 'View bookings',
            subtitle: 'Checked-in and closed vehicles',
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const BookingsListScreen())),
          ),
          const SizedBox(height: 18),
          _MenuCard(
            icon: Icons.inventory_2_outlined,
            tone: AppTone.gold,
            title: 'Stock',
            subtitle: 'View and manage parts inventory',
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const StockListScreen())),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.onTap,
    this.valueColor = AppColors.text,
  });

  final String value;
  final String label;
  final VoidCallback onTap;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.heading(20, color: valueColor)),
          const SizedBox(height: 2),
          Text(label, style: AppText.body(12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconChip(icon: icon, tone: tone),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.heading(16, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppText.body(13, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textFaint),
        ],
      ),
    );
  }
}
