import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFFEF476F), // romantic pink/red accent
    brightness: Brightness.dark,
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    )),
  );
}
