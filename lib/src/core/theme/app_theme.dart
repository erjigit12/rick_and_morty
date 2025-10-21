// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const seedColor = Color(0xFF4CAF50);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      background: const Color(0xFFF2F2F7),
      surface: Colors.white,
    ).copyWith(onSurfaceVariant: Colors.grey.shade600);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
      ),
      cardColor: colorScheme.surface,
      textTheme: _buildTextTheme(colorScheme, isDark: false),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.background,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(height: 2),
        unselectedLabelStyle: TextStyle(
          height: 2,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dividerColor: colorScheme.onSurfaceVariant.withOpacity(0.2),
    );
  }

  static ThemeData dark() {
    const background = Color(0xFF24282F);
    const surface = Color(0xFF3C3E44);
    const seedColor = Color(0xFF4CAF50);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      background: background,
      surface: surface,
    ).copyWith(onSurfaceVariant: Colors.grey.shade400);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
      ),
      cardColor: colorScheme.surface,
      textTheme: _buildTextTheme(colorScheme, isDark: true),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.background,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(height: 2),
        unselectedLabelStyle: TextStyle(
          height: 2,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dividerColor: colorScheme.onSurfaceVariant.withOpacity(0.2),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme, {required bool isDark}) {
    final base = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return base.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }
}
