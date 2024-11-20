import 'package:flutter/material.dart';

const List<Color> colorList = [
  Color.fromARGB(255, 0, 119, 216),
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent
];

class AppTheme {

  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = false,
  }): assert(selectedColor >= 0, 'El color de tema seleccionado debe de ser mayor a 0'),
      assert(selectedColor < colorList.length, 'El color de tema seleccionado debe de ser menor o igual a ${colorList.length - 1}');

  ColorScheme _getColorScheme(Color color) {
    return ColorScheme(
      primary: color,
      secondary: color.withOpacity(0.7), // Ajusta la opacidad para hacer el color más claro,
      surface: isDarkmode ? Colors.grey[800]! : Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: isDarkmode ? Colors.white : Colors.black,
      surfaceContainerLowest: isDarkmode ? Colors.grey[900]! : Colors.white,
      onError: Colors.white,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
    );
  }

  ThemeData getTheme() {
    final colorScheme = _getColorScheme(colorList[selectedColor]);

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false
      )
    );

  } 

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkmode
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );

}