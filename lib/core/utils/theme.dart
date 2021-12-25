import 'package:flutter/material.dart';

class AppTheme {
  // constructor
  const AppTheme();

  //  main colors
  static const Color primaryColor = Color(0xFF76B7B9);
  static const Color secondaryColor = Color(0xFFEE7053);

  // font color
  static const Color fontDarkColor = Color(0xFF111111);
  static const Color fontLightColor = Color(0xFF9D9EA1);

  // other colors
  static const Color cardColor = Color(0xFFF8F7FB);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFFF8399);

  // ubq theme data
  static ThemeData getAppThemeData() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Sora',
      indicatorColor: primaryColor,
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: fontLightColor,
        selectionHandleColor: primaryColor,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.w700,
          color: fontDarkColor,
        ),
        headline2: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w300,
          color: fontDarkColor,
        ),
        headline3: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: fontDarkColor,
        ),
        headline4: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: fontDarkColor,
        ),
        headline5: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: fontDarkColor,
        ),
        headline6: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: fontDarkColor,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: fontDarkColor,
        ),
        bodyText2: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: fontDarkColor,
        ),
        subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: fontLightColor,
        ),
        button: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(54.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          overlayColor: MaterialStateProperty.all(
            primaryColor.withOpacity(0.1),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(54.0),
          ),
          elevation: 0.0,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(54.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(54.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(54.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(54.0),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(54.0),
          borderSide: BorderSide.none,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontFamily: 'Plus Jakarta Text',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16.0,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Plus Jakarta Text',
          fontWeight: FontWeight.w400,
          color: fontLightColor,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
