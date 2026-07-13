import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkmode;

  AppTheme({this.isDarkmode = false});

  ColorScheme get _colorScheme => isDarkmode ? _darkColorScheme : _lightColorScheme;

  static const _lightColorScheme = ColorScheme.light(
    primary: Color(0xFFF54927),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD6CC),
    onPrimaryContainer: Color(0xFF3D0A00),
    secondary: Color(0xFF4A4A4A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8E8E8),
    onSecondaryContainer: Color(0xFF1C1C1C),
    tertiary: Color(0xFF6C6C6C),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF2F2F2),
    onTertiaryContainer: Color(0xFF1C1C1C),
    error: Color(0xFFF54927),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFD6CC),
    onErrorContainer: Color(0xFF3D0A00),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1C1C),
    surfaceContainerHighest: Color(0xFFF2F2F2),
    onSurfaceVariant: Color(0xFF6C6C6C),
    outline: Color(0xFFD4D4D4),
    outlineVariant: Color(0xFFE8E8E8),
    inverseSurface: Color(0xFF1C1C1C),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFFF7A5C),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFF54927),
  );

  static const _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFFFF7A5C),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF5C0E00),
    onPrimaryContainer: Color(0xFFFFD6CC),
    secondary: Color(0xFFB0B0B0),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF3A3A3A),
    onSecondaryContainer: Color(0xFFE8E8E8),
    tertiary: Color(0xFF8C8C8C),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF2A2A2A),
    onTertiaryContainer: Color(0xFFE8E8E8),
    error: Color(0xFFFF7A5C),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFF5C0E00),
    onErrorContainer: Color(0xFFFFD6CC),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFC4C4C4),
    outline: Color(0xFF4A4A4A),
    outlineVariant: Color(0xFF3A3A3A),
    inverseSurface: Color(0xFFFFFFFF),
    onInverseSurface: Color(0xFF1C1C1C),
    inversePrimary: Color(0xFFF54927),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFFF7A5C),
  );

  ThemeData getTheme() {
    final cs = _colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),

      navigationBarTheme: NavigationBarThemeData(
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),



      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: cs.outlineVariant,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0),
        displaySmall: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineLarge: TextStyle(fontWeight: FontWeight.w500, letterSpacing: -0.25),
        headlineMedium: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0),
        headlineSmall: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0),
        titleLarge: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.15),
        titleSmall: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyLarge: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
    );
  }

  AppTheme copyWith({bool? isDarkmode}) => AppTheme(
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );
}
