import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/core/defined_fonts/defined_font_families.dart';

class Themes {
  // Light Theme
  static const Color lightPrimaryColor = Color(0xFFB7935F);
  static const Color lightSecondaryColor = Color(0xFF242424);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    indicatorColor: lightPrimaryColor,
    primaryIconTheme: const IconThemeData(color: lightPrimaryColor),
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        color: Colors.white,
        surfaceTintColor: null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    textTheme: TextTheme(
        // for the label on the bottom of the splash screen
        labelSmall: TextStyle(
            fontSize: 20,
          color: lightPrimaryColor,
          fontFamily: GoogleFonts.poppins().fontFamily),
      titleSmall: const TextStyle(
          fontSize: 25,
          color: lightSecondaryColor,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w500),
      titleMedium: const TextStyle(
          fontSize: 30,
          color: lightSecondaryColor,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w700),
      bodySmall: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
        // for displaying suras and ahadeeth:
        displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.normal,
            fontFamily: GoogleFonts.amiriQuran().fontFamily)),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: lightPrimaryColor),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 30,
          color: lightSecondaryColor,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w700),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(6),
      hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      suffixIconColor: lightPrimaryColor,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: lightPrimaryColor)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.blue)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            textStyle: MaterialStatePropertyAll(
                GoogleFonts.ibmPlexSansArabic(fontSize: 30)),
            backgroundColor: const MaterialStatePropertyAll(lightPrimaryColor),
            shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
            side: const MaterialStatePropertyAll(BorderSide.none))),
    buttonTheme: const ButtonThemeData(
      padding: EdgeInsets.all(10),
      shape: ContinuousRectangleBorder(
          side: BorderSide(color: lightPrimaryColor, width: 3)),
    ),
    dividerTheme:
        const DividerThemeData(color: lightPrimaryColor, thickness: 3),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: lightSecondaryColor,
      selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
          fontSize: 18,
          color: lightSecondaryColor),
      unselectedLabelStyle:
          const TextStyle(fontSize: 0, color: lightPrimaryColor),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,
      backgroundColor: lightPrimaryColor,
      type: BottomNavigationBarType.fixed,
    ),
  );

  //-------------------------------------------------
  // Dark Theme
  static const Color darkPrimaryColor = Color(0xFFFACC1D);
  static const Color darkSecondaryColor = Color(0xFF141A2E);
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    indicatorColor: darkPrimaryColor,
    primaryIconTheme: const IconThemeData(color: darkPrimaryColor),
    iconTheme: const IconThemeData(color: darkPrimaryColor, size: 45),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSecondaryColor,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        color: darkSecondaryColor,
        surfaceTintColor: null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    dialogTheme: DialogTheme(
        backgroundColor: darkSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    textTheme: TextTheme(
        // for the label on the bottom of the splash screen
        labelSmall: TextStyle(
            fontSize: 20,
            color: darkPrimaryColor,
          fontFamily: GoogleFonts.poppins().fontFamily),
      titleSmall: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w500),
      titleMedium: const TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w700),
      bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
        // for displaying suras and ahadeeth:
        displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.normal,
            fontFamily: GoogleFonts.amiriQuran().fontFamily)),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: darkPrimaryColor),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontFamily: DefinedFontFamilies.elMessiri,
          fontWeight: FontWeight.w700),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(6),
      hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
      suffixIconColor: darkPrimaryColor,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: darkPrimaryColor)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.blue)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.black),
            textStyle: MaterialStatePropertyAll(
                GoogleFonts.ibmPlexSansArabic(fontSize: 30)),
            backgroundColor: const MaterialStatePropertyAll(darkPrimaryColor),
            shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
            side: const MaterialStatePropertyAll(BorderSide.none))),
    buttonTheme: const ButtonThemeData(
      padding: EdgeInsets.all(10),
      shape: ContinuousRectangleBorder(
          side: BorderSide(color: darkPrimaryColor, width: 3)),
    ),
    dividerTheme: const DividerThemeData(color: darkPrimaryColor, thickness: 3),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: darkPrimaryColor,
      selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
          fontSize: 18,
          color: darkPrimaryColor),
      unselectedLabelStyle:
          const TextStyle(fontSize: 0, color: darkSecondaryColor),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,
      backgroundColor: darkSecondaryColor,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
