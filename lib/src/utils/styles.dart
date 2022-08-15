import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ripple.dart';

class Styles {
  static bool isDark = false;

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      // surface: Colors.white,
      onSurface: Color(0xff222222),
      primary: Color(0xffce4a4f),
      onPrimary: Colors.white,
      primaryContainer: Color(0xffe07356),
      secondary: Color(0xff2b2540),
      secondaryContainer: Color(0xff483F6C),
      onSecondary: Colors.white,
      background: Color(0xfff3f6f9),
      onBackground: Color(0xff222222),
    ),
    shadowColor: const Color(0xff222222).withOpacity(0.05),
    textTheme: GoogleFonts.mulishTextTheme(),
    dividerColor: const Color(0xff6C6F8D),
    canvasColor: const Color(0x7fc3e8f3),
    scaffoldBackgroundColor: const Color(0xfff3f6f9),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(splashFactory: const BookRippleFactory()),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xffce4a4f),
      onPrimary: Colors.white,
      secondary: Color(0xff917DD8),
      onSecondary: Colors.white,
      background: Color(0xff222222),
      onBackground: Color(0xfff3f6f9),
    ),
    textTheme: GoogleFonts.mulishTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      decorationColor: Colors.white,
    ),
    hintColor: const Color(0xFFADADAD),
    shadowColor: const Color(0xff939393).withOpacity(0.05),
    dividerColor: const Color(0xff48445D),
    canvasColor: const Color(0x7f30393E),
    scaffoldBackgroundColor: const Color(0xff222222),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(splashFactory: const BookRippleFactory()),
    ),
  );

  ThemeData get theme => isDark ? darkTheme : lightTheme;
}
