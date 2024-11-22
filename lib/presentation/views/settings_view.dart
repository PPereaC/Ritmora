import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme/theme_provider.dart';

// Asegúrate de que isDarkmodeProvider sea un StateProvider<bool>
final isDarkmodeProvider = StateProvider<bool>((ref) => false);

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    // Observa el estado del proveedor
    final isDarkMode = ref.watch(isDarkmodeProvider);
    final themeProvider = ref.watch(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Modo Oscuro', style: Theme.of(context).textTheme.bodyLarge),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                // Actualiza el estado del proveedor
                ref.read(isDarkmodeProvider.notifier).state = value;
                themeProvider.toggleDarkmode();
              },
            ),
          ),
        ],
      ),
    );
  }
}