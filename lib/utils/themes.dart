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
    surface: Color.fromARGB(255, 163, 222, 249),
    primary: Colors.black,
    secondary: Colors.black87,
    tertiary: Color.fromARGB(255, 97, 97, 97),
    primaryContainer: Color.fromARGB(255, 148, 206, 233),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black.withOpacity(0.8),
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF0F1026),
    primary: Colors.white,
    secondary: Colors.white70,
    tertiary: const Color.fromRGBO(180, 180, 180, 1),
    primaryContainer: const Color.fromARGB(255, 51, 53, 71).withOpacity(0.3),
  ),
);

ThemeData bottomNavBarTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  textTheme: textTheme,
);
