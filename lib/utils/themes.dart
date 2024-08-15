import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme = TextTheme(
  bodyLarge: GoogleFonts.poppins(fontSize: 22.0),
  bodyMedium: GoogleFonts.poppins(fontSize: 18.0),
  bodySmall: GoogleFonts.poppins(fontSize: 14.0),
  titleLarge: GoogleFonts.poppins(fontSize: 24.0),
  titleSmall: GoogleFonts.poppins(fontSize: 16.0),
  titleMedium: GoogleFonts.poppins(fontSize: 18.0),
  labelLarge: GoogleFonts.poppins(fontSize: 54.0),
  labelSmall: GoogleFonts.poppins(fontSize: 18.0),
  labelMedium: GoogleFonts.poppins(fontSize: 32.0),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white.withOpacity(0.9),
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 163, 222, 249),
    primary: Colors.black,
    secondary: Colors.black87,
    tertiary: Color.fromARGB(255, 97, 97, 97),
    surface: Color.fromARGB(255, 78, 81, 126),
    primaryContainer: Color.fromARGB(255, 152, 203, 227),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black.withOpacity(0.8),
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF0F1026),
    primary: Colors.white,
    secondary: Colors.white70,
    tertiary: Color.fromRGBO(180, 180, 180, 1),
    surface: Colors.blueGrey,
    primaryContainer: Color.fromARGB(255, 51, 53, 71),
  ),
);

ThemeData bottomNavBarTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  textTheme: textTheme,
);
