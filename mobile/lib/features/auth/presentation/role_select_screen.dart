import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';
import '../providers/current_role_provider.dart';

class RoleSelectScreen extends ConsumerWidget{
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(currentRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select role')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            currentRole == null
            ? 'No role selected'
            : 'Currently: ${currentRole.displayName}',
          style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16,),
          for (final role in UserRole.values)
          Card(
            child: ListTile(
              leading: Icon(
                role == UserRole.admin ? Icons.admin_panel_settings : Icons.build,
                ),
                title: Text(role.displayName),
                trailing: currentRole == role ? const Icon(Icons.check_circle) : null,
                onTap: () {
                  ref.read(currentRoleProvider.notifier).state = role;
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }
}