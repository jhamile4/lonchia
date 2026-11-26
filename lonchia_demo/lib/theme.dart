import 'package:flutter/material.dart';

/// Paleta inspirada en el ODS 12 (dorado #BF8B2E) más verdes de alimentos frescos.
class LC {
  static const dorado = Color(0xFFBF8B2E); // color oficial del ODS 12
  static const doradoClaro = Color(0xFFF6E7C8);
  static const verde = Color(0xFF2F8F5B);
  static const verdeClaro = Color(0xFFDDF1E4);
  static const crema = Color(0xFFFFF9F0);
  static const tinta = Color(0xFF2B2A28);
  static const coral = Color(0xFFF2765B);
}

ThemeData lonchiaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: LC.verde,
    primary: LC.verde,
    secondary: LC.dorado,
    surface: LC.crema,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: LC.crema,
    appBarTheme: const AppBarTheme(
      backgroundColor: LC.crema,
      foregroundColor: LC.tinta,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: LC.tinta),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: LC.doradoClaro,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    ),
  );
}
