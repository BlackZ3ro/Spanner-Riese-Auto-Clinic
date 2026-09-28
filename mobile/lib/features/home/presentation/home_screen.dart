import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/presentation/bookings_list_screen.dart';
import '../../stock/presentation/stock_list_screen.dart';

class HomeScreen extends ConsumerWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riese Auto Clinic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(profileAsync.when(
                  data: (profile) => 
                    profile == null ? 'Signed in' : 'Signed in as: ${profile.role.displayName}',
                  loading: () => 'Loading...',
                  error: (_, __) => 'Signed in',
              ),
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