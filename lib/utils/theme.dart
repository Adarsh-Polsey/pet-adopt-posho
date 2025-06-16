import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/utils/app_pallette.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme');
    state = ThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', mode.name);
    state = mode;
  }
}
class MyTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1),
    borderRadius: BorderRadius.circular(26),
  );

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(color: color, fontSize: 57),
      displayMedium: TextStyle(color: color, fontSize: 45),
      displaySmall: TextStyle(color: color, fontSize: 36),

      headlineLarge: TextStyle(color: color, fontSize: 32),
      headlineMedium: TextStyle(color: color, fontSize: 28),
      headlineSmall: TextStyle(color: color, fontSize: 24),

      titleLarge: TextStyle(
        color: color,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      bodyMedium: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      bodySmall: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),

      labelLarge: TextStyle(
        color: Pallete.primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: Pallete.primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Pallete.primaryColor,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static final darkThemeMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Pallete.primaryColor,
      onPrimary: Pallete.blackColor,
      primaryContainer: Color(0xFF2A2A2A),
      secondary: Color(0xFFBB86FC),
      onSecondary: Colors.black,
      tertiary: Color(0xFF03DAC6),
      onTertiary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF121212),
      onSurface: Color(0xFFE0E0E0),

      onSurfaceVariant: Color(0xFFB0B0B0),
      outline: Color(0xFF797979),
    ),
    scaffoldBackgroundColor: Pallete.backgroundColor,
    primaryColor: Pallete.primaryColor,
    textTheme: _textTheme(Pallete.whiteColor),
    inputDecorationTheme: InputDecorationTheme(
      disabledBorder: _border(Pallete.primaryLight.withValues(alpha: 0.2)),
      border: _border(Pallete.primaryLight.withValues(alpha: 0.2)),
      enabledBorder: _border(Pallete.primaryLight.withValues(alpha: 0.2)),
      focusedBorder: _border(Pallete.primaryLight.withValues(alpha: 0.5)),
      contentPadding: const EdgeInsets.all(27),
      fillColor: Pallete.blueGreyDark,
      filled: true,
      errorStyle: const TextStyle(fontSize: 5),
      errorMaxLines: 2,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Pallete.backgroundColor,
      contentTextStyle: TextStyle(color: Pallete.whiteColor),
      actionTextColor: Pallete.whiteColor,
      elevation: 1,
      showCloseIcon: true,
      dismissDirection: DismissDirection.up,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.transparentColor,
        shadowColor: Pallete.blackColor,
        foregroundColor: Pallete.whiteColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Pallete.whiteColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Pallete.backgroundColor,
      selectedItemColor: Pallete.primaryColor,
      unselectedItemColor: Pallete.whiteColor,
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Pallete.backgroundColor,
      foregroundColor: Pallete.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Pallete.primaryColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Pallete.primaryColor,
      foregroundColor: Pallete.whiteColor,
    ),
    iconTheme: IconThemeData(color: Pallete.primaryColor),
    dialogTheme: DialogThemeData(
      backgroundColor: Pallete.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    cardTheme: CardThemeData(
      color: Pallete.backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static final lightThemeMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Pallete.whiteColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Pallete.primaryColor,
      onPrimary: Pallete.whiteColor,
      primaryContainer: Pallete.greyColor,
      secondary: Pallete.gradient1,
      onSecondary: Pallete.gradient2,
      tertiary: Pallete.gradient3,
      onTertiary: Pallete.gradient4,
      error: Pallete.blackColor,
      onError: Pallete.primaryColor,
      surface: Pallete.whiteColor,
      onSurface: Pallete.blackColor,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      side: BorderSide(color: Color(0xFFFFB9B9), width: 0),
      color: WidgetStateProperty.all(Color(0xFFFFB9B9)),
      labelStyle: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
    textTheme: _textTheme(Pallete.blackColor),
    inputDecorationTheme: InputDecorationTheme(
      disabledBorder: _border(Pallete.greyColor.withValues(alpha: 0.1)),
      border: _border(Pallete.greyColor.withValues(alpha: 0.1)),
      enabledBorder: _border(Pallete.blueGreyDark.withValues(alpha: 0.1)),
      focusedBorder: _border(Pallete.blueGreyDark.withValues(alpha: 0.5)),
      contentPadding: const EdgeInsets.all(27),
      fillColor: Pallete.whiteColor,
      filled: true,
      errorStyle: const TextStyle(fontSize: 5),
      errorMaxLines: 2,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Pallete.backgroundColor,
      contentTextStyle: TextStyle(color: Pallete.blackColor),
      actionTextColor: Pallete.blackColor,
      elevation: 2,
      showCloseIcon: true,
      dismissDirection: DismissDirection.up,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.primaryColor,
        shadowColor: Colors.transparent,
        foregroundColor: Pallete.whiteColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Pallete.primaryColor,
        shadowColor: Colors.transparent,
        foregroundColor: Pallete.whiteColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Pallete.backgroundColor,
      foregroundColor: Pallete.blackColor,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Pallete.whiteColor,
      selectedItemColor: Pallete.primaryColor,
      unselectedItemColor: Pallete.blackColor,
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Pallete.primaryColor,
      foregroundColor: Pallete.whiteColor,
    ),
    iconTheme: IconThemeData(color: Pallete.primaryColor),
    dialogTheme: DialogThemeData(
      backgroundColor: Pallete.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
