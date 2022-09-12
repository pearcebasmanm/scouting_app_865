import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum Themes {
  defaultLight,
  defaultDark,
  light,
  dark,
  customLight,
  customDark,
}

CustomTheme currentTheme = CustomTheme();
const platform = MethodChannel('com.example.app/colors');

class CustomTheme with ChangeNotifier {
  // static const Theme _themes = Themes.defaultDark;
  static bool _isDarkTheme = true;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData theme(Themes theme) {
    var colorScheme = _getColorScheme(theme);

    return ThemeData(
      colorScheme: colorScheme,
      iconTheme: IconThemeData(color: colorScheme.inverseSurface),
      bottomAppBarColor: colorScheme.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 10)),
          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 30)),
        ),
      ),
      cardColor: colorScheme.secondary,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: GoogleFonts.latoTextTheme(
        // Specific Text Changes
        const TextTheme(
          headline5: TextStyle(fontWeight: FontWeight.bold),
        ),
      ).apply(
        // Broad Text Changes
        displayColor: colorScheme.onSurface,
        bodyColor: colorScheme.onSurface,
      ),
    );
  }

  static _getColorScheme(Themes theme) {
    switch (theme) {
      case Themes.defaultLight:
        return const ColorScheme.light();
      case Themes.defaultDark:
        return const ColorScheme.dark();
      case Themes.light:
        return ColorScheme.light(
          primary: const Color.fromARGB(255, 30, 45, 74),
          secondary: Colors.blue[200]!,
        );
      case Themes.dark:
        return ColorScheme.dark(
          primary: const Color.fromARGB(255, 41, 89, 185),
          secondary: const Color.fromARGB(255, 30, 45, 74),
          onSurface: Colors.grey[300]!,
        );
      case Themes.customLight:
        return ColorScheme.light(
          primary: Colors.indigo[800]!,
          secondary: Colors.brown[200]!,
        );
      case Themes.customDark:
        return const ColorScheme.dark();
    }
  }
}
