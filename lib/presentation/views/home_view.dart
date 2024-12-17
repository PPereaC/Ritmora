import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkMode = ref.watch(isDarkmodeProvider);
    final themeProvider = ref.watch(themeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Inicio',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleDarkmode(),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDarkMode ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}