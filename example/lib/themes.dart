import 'package:flutter/material.dart';
import 'package:flutterbook/flutterbook.dart';

class Themes {
  static List<FlutterBookTheme> themes = [
    FlutterBookTheme(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          onSurface: Color(0xff222222),
          primary: Color(0xffce4a4f),
          primaryContainer: Color(0xffe07356),
          secondary: Color(0xff2b2540),
          secondaryContainer: Color(0xff483F6C),
          onSecondary: Colors.white,
          background: Color(0xfff3f6f9),
          onBackground: Color(0xff222222),
        ),
        dividerColor: const Color(0xff6C6F8D),
        canvasColor: const Color(0x7fc3e8f3),
        scaffoldBackgroundColor: const Color(0xfff3f6f9),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeName: 'Light Theme',
    ),
    FlutterBookTheme(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xffce4a4f),
          onPrimary: Colors.white,
          secondary: Color(0xff917DD8),
          onSecondary: Colors.white,
          background: Color(0xff222222),
          onBackground: Color(0xfff3f6f9),
        ),
        hintColor: const Color(0xFFADADAD),
        dividerColor: const Color(0xff48445D),
        canvasColor: const Color(0x7f30393E),
        scaffoldBackgroundColor: const Color(0xff222222),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeName: 'Dark Theme',
    ),
    FlutterBookTheme(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          onSurface: Color(0xff222222),
          onPrimary: Colors.white,
          primary: Color.fromARGB(255, 206, 197, 74),
          primaryContainer: Color(0xffe07356),
          secondary: Color(0xff2b2540),
          secondaryContainer: Color(0xff483F6C),
          onSecondary: Colors.white,
          background: Color(0xfff3f6f9),
          onBackground: Color(0xff222222),
        ),
        dividerColor: const Color(0xff6C6F8D),
        canvasColor: const Color(0x7fc3e8f3),
        scaffoldBackgroundColor: Color.fromARGB(255, 244, 255, 150),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeName: 'Sunny Theme',
    ),
  ];
}
