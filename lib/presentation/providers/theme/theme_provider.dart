import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/app_theme.dart';

final isDarkmodeProvider = StateProvider((ref) => false);

// Listado de colores inmutable
final colorListProvider = Provider((ref) => colorList);

// Un simple int
final selectedColorProvider = StateProvider((ref) => 0);

// Un objeto de tipo AppTheme (custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  final Ref ref;

  ThemeNotifier(this.ref) : super(AppTheme()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkmode = prefs.getBool('isDarkmode') ?? false;
    
    state = AppTheme(isDarkmode: isDarkmode);
    ref.read(isDarkmodeProvider.notifier).state = isDarkmode;
  }

  void toggleDarkmode() async {
    state = state.copyWith(isDarkmode: !state.isDarkmode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkmode', state.isDarkmode);

    ref.read(isDarkmodeProvider.notifier).state = state.isDarkmode;
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}