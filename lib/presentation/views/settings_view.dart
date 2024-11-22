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
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Modo Oscuro', style: Theme.of(context).textTheme.bodyLarge),
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