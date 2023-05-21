import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PachaTheme {
  static ThemeData get get {
    return ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.compact,
        // ignore: deprecated_member_use
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.amber,
        // ignore: deprecated_member_use
        accentColor: Colors.amberAccent,
        shadowColor: Colors.grey,
        indicatorColor: Colors.yellow,
        toggleableActiveColor: Colors.amber,
        focusColor: Colors.amber,
        appBarTheme: const AppBarTheme(toolbarHeight: 54),
        textTheme: GoogleFonts.getTextTheme(
            "Raleway",
            const TextTheme(
              headline1: TextStyle(
                fontSize: 42,
              ),
              headline2: TextStyle(
                fontSize: 38,
              ),
              headline3: TextStyle(
                fontSize: 34,
              ),
              headline4: TextStyle(
                fontSize: 30,
              ),
              headline5: TextStyle(
                fontSize: 26,
              ),
              headline6: TextStyle(
                fontSize: 22,
              ),
              overline: TextStyle(
                fontSize: 12,
              ),
              subtitle1: TextStyle(
                fontSize: 22,
              ),
              subtitle2: TextStyle(
                fontSize: 20,
              ),
              bodyText1: TextStyle(
                fontSize: 18,
              ),
              bodyText2: TextStyle(
                fontSize: 16,
              ),
              button: TextStyle(
                fontSize: 18,
              ),
              caption: TextStyle(
                fontSize: 14,
              ),
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              letterSpacing: 0,
            ),
            border: OutlineInputBorder()));
  }
}
