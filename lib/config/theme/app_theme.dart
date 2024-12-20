import 'package:flutter/material.dart';

const List<Color> colorList = [
  Color.fromRGBO(50, 15, 224, 1)
];

class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color onError;

  ThemeColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onError,
  });
}

class AppTheme {
  final int selectedColor;
  final ThemeColors? customColors;

  AppTheme({
    this.selectedColor = 0,
    this.customColors,
  }) : assert(selectedColor >= 0, 'El color de tema seleccionado debe de ser mayor a 0'),
       assert(selectedColor < colorList.length, 'El color de tema seleccionado debe de ser menor o igual a ${colorList.length - 1}');

  ThemeColors _getDefaultColors(Color primaryColor) {
    return ThemeColors(
      primary: primaryColor,
      secondary: const Color(0xFF697586),
      surface: Colors.black,
      error: Colors.red[800]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.black,
    );
  }

  ColorScheme _getColorScheme() {
    final baseColor = colorList[selectedColor];
    final colors = customColors ?? _getDefaultColors(baseColor);

    return ColorScheme(
      brightness: Brightness.dark,
      primary: colors.primary,
      secondary: colors.secondary,
      surface: colors.surface,
      error: colors.error,
      onPrimary: colors.onPrimary,
      onSecondary: colors.onSecondary,
      onSurface: colors.onSurface,
      onError: colors.onError,
    );
  }

  ThemeData getTheme() {
    final colorScheme = _getColorScheme();
    final colors = customColors ?? _getDefaultColors(colorList[selectedColor]);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
      ),
      scaffoldBackgroundColor: colors.surface,
      textTheme: const TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  AppTheme copyWith({
    int? selectedColor,
    ThemeColors? customColors,
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    customColors: customColors ?? this.customColors,
  );
}