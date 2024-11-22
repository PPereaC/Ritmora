import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme/theme_provider.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(themeNotifierProvider.notifier);
    final isDarkmode = ref.watch(isDarkmodeProvider);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo Oscuro',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Activa esta opción para cambiar al tema oscuro de la aplicación.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: isDarkmode,
              onChanged: (value) {
                themeProvider.toggleDarkmode();
              },
            ),
          ),
        ],
      ),
    );
  }
}