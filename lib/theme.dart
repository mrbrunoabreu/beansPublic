import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      hintColor: Colors.black,
      primarySwatch: Colors.blue,
      primaryColorDark: Colors.grey[200],
      buttonColor: Colors.lightBlue[900],
      scaffoldBackgroundColor: const Color(0xffeef2f5),
      backgroundColor: Colors.white,
      cardColor: Colors.white,
      indicatorColor: Colors.grey[200],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.black87),
          bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              color: Colors.black87),
          headline1: TextStyle(
              fontSize: 24.0, fontFamily: 'Montserrat', color: Colors.black87),
          headline2: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black87),
          headline3: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          headline4: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w200,
              color: Colors.grey),
          headline5: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.black),
          headline6: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.grey),
          subtitle1: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Sacramento',
              fontStyle: FontStyle.italic,
              color: Colors.blue),
          subtitle2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: Colors.black54),
          button: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.white)),
      buttonTheme: const ButtonThemeData(
        minWidth: 50),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w200,
            color: Colors.black87),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.blueGrey[400]!.withOpacity(0.2)
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: const Color(0xffeef2f5),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black87
      ),
      );

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      hintColor: Colors.white,
      accentColor: Colors.blue,
      primarySwatch: Colors.blue,
      primaryColorDark: const Color(0xFF36364b),
      buttonColor: Colors.lightBlue,
      scaffoldBackgroundColor: const Color(0xFF1c1c28),
      backgroundColor: const Color(0xFF121219),
      cardColor: const Color(0xFF2e2e41),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              color: Colors.white70),
          headline1: TextStyle(
              fontSize: 24.0, fontFamily: 'Montserrat', color: Colors.white),
          headline2: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.white),
          headline3: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.white),
          headline4: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w200,
              color: Colors.grey),
          headline5: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.white),
          headline6: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.grey),
          subtitle1: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Sacramento',
              fontStyle: FontStyle.italic,
              color: Color(0xFF64B5f6)),
          subtitle2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: Colors.white70),
          button: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Colors.black)),
      buttonTheme: const ButtonThemeData(minWidth: 50),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w200,
            color: Colors.white70),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF2e2e41),
        shadowColor: Colors.black54
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: const Color(0xFF1c1c28),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white70
      ),
      );
}
