import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/role_select_screen.dart';
import '../../auth/providers/current_role_provider.dart';
import '../../stock/presentation/stock_list_screen.dart';
import '../../bookings/presentation/bookings_list_screen.dart';

class HomeScreen extends ConsumerWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(currentRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riese Auto Clinic')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                currentRole == null
                  ? 'No role selected'
                  : 'Signed in as: ${currentRole.displayName}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _HomeMenuCard(
            icon : Icons.directions_car,
            title: 'View bookings',
            subtitle: 'View checked-in vehicles and closed vehicles',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BookingsListScreen()),
            ),
          ),
          _HomeMenuCard(
            icon: Icons.inventory_2,
            title: 'Stock',
            subtitle: 'View and manage parts inventory',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StockListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget{
  const _HomeMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32,),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}