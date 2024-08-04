import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      primaryColor: const Color(0xFFB7935F),
      shadowColor: const Color(0xFFd4d2d2),
      cardColor: Colors.white,
      textTheme: TextTheme(
        bodySmall: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
        bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
        bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFB7935F)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle:
                  const MaterialStatePropertyAll(TextStyle(fontSize: 30)),
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFFB7935F)),
              shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
              side: const MaterialStatePropertyAll(BorderSide.none))),
      buttonTheme: const ButtonThemeData(
        padding: EdgeInsets.all(10),
        shape: ContinuousRectangleBorder(
            side: BorderSide(color: Color(0xFFB7935F), width: 3)),
      ),
      dividerTheme:
          const DividerThemeData(color: Color(0xFFB7935F), thickness: 3),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 30,
            color: const Color(0xFF242424),
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFF242424),
        selectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
            fontSize: 18,
            color: Colors.black),
        unselectedLabelStyle:
            const TextStyle(fontSize: 0, color: Color(0xFFB7935F)),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        backgroundColor: const Color(0xFFB7935F),
        type: BottomNavigationBarType.fixed,
      ));

  //-------------------------------------------------
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
    primaryColor: const Color(0xFFFACC1D),
    shadowColor: const Color(0xFFFACC1D),
    cardColor: const Color(0xFF141A2E),
    textTheme: TextTheme(
      bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 30)),
            backgroundColor: const MaterialStatePropertyAll(Color(0xFFFACC1D)),
            shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
            side: const MaterialStatePropertyAll(BorderSide.none))),
    buttonTheme: const ButtonThemeData(
      padding: EdgeInsets.all(10),
      shape: ContinuousRectangleBorder(
          side: BorderSide(color: Color(0xFFFACC1D), width: 3)),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 30,
          color: const Color(0xFFF8F8F8),
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFACC1D)),
    dividerTheme:
        const DividerThemeData(color: Color(0xFFFACC1D), thickness: 3),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFFFACC1D),
      selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
          fontSize: 18,
          color: const Color(0xFFFACC1D)),
      unselectedLabelStyle:
          const TextStyle(fontSize: 0, color: Color(0xFF141A2E)),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,
      backgroundColor: const Color(0xFF141A2E),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
