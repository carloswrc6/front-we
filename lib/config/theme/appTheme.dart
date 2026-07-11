import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkmode;

  AppTheme({this.isDarkmode = false});

  ColorScheme get _colorScheme => isDarkmode ? _darkColorScheme : _lightColorScheme;

  static const _lightColorScheme = ColorScheme.light(
    primary: Color(0xFFE67E22),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFE8D0),
    onPrimaryContainer: Color(0xFF4A2800),
    secondary: Color(0xFF2E8B57),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC8F0D8),
    onSecondaryContainer: Color(0xFF002112),
    tertiary: Color(0xFF6B5B8A),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEDDFFF),
    onTertiaryContainer: Color(0xFF251843),
    error: Color(0xFFE74C3C),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFFF8F2),
    onSurface: Color(0xFF2C3E50),
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF4A4A4A),
    outline: Color(0xFFD9D9D9),
    outlineVariant: Color(0xFFC4C4C4),
    inverseSurface: Color(0xFF2C3E50),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFF2994A),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFE67E22),
  );

  static const _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFFF2994A),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF663500),
    onPrimaryContainer: Color(0xFFFFDCC0),
    secondary: Color(0xFF6FCF97),
    onSecondary: Color(0xFF003819),
    secondaryContainer: Color(0xFF00522C),
    onSecondaryContainer: Color(0xFFACF2C4),
    tertiary: Color(0xFFD1C0F5),
    onTertiary: Color(0xFF3B2D59),
    tertiaryContainer: Color(0xFF524370),
    onTertiaryContainer: Color(0xFFEDDFFF),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFC4C4C4),
    outline: Color(0xFF4A4A4A),
    outlineVariant: Color(0xFF3A3A3A),
    inverseSurface: Color(0xFFFFFFFF),
    onInverseSurface: Color(0xFF2C3E50),
    inversePrimary: Color(0xFFE67E22),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFF2994A),
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
