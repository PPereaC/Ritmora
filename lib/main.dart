import 'package:apolo/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

void main() async {
  
  // Esto es crucial - asegura que los plugins estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar la base de datos
  final databasesPath = await getDatabasesPath();
  // ignore: unused_local_variable
  final path = join(databasesPath, 'cache.db');

  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: appTheme.selectedColor).getTheme(),
    );
  }
}
