import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    // Makes widgets using defaults the right color
    colorScheme: palette(),

    // Gives the action buttons (the dark ones) some vertical space and big text
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding:
            MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 30)),
      ),
    ),

    // Makes the increment/decrement sections rounded and colored
    cardColor: palette().secondary,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

ColorScheme palette() {
  return ColorScheme.light(
    primary: const Color.fromARGB(255, 30, 45, 74),
    secondary: Colors.blue[200]!,
  );
}
