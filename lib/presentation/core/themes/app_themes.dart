import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamy_app/presentation/core/defined_fonts/defined_font_families.dart';

class Themes {
  // Light Theme
  static const Color lightPrimaryColor = Color(0xFFB7935F);
  static const Color lightSecondaryColor = Color(0xFF242424);

  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      indicatorColor: lightPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: lightPrimaryColor),
      iconTheme: const IconThemeData(color: lightPrimaryColor, size: 30),
      sliderTheme: SliderThemeData(
        trackHeight: 15,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
        activeTrackColor: lightPrimaryColor.withAlpha(100),
        inactiveTrackColor: Colors.grey.withAlpha(125),
        thumbColor: lightPrimaryColor,
        valueIndicatorColor: lightPrimaryColor.withAlpha(125),
        valueIndicatorTextStyle:
        const TextStyle(color: Colors.white, fontSize: 20),
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0.8),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: lightPrimaryColor.withAlpha(140),
      ),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white,
          showDragHandle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          surfaceTintColor: null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      textTheme: TextTheme(
        titleMedium: const TextStyle(
            fontSize: 25,
            color: lightSecondaryColor,
            fontFamily: DefinedFontFamilies.elMessiri,
            fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
        // for displaying suras and ahadeeth:
        displayLarge: GoogleFonts.notoSansArabic(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 40),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: lightPrimaryColor),
        color: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 25,
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
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              textStyle: WidgetStatePropertyAll(
                  GoogleFonts.ibmPlexSansArabic(fontSize: 20)),
              backgroundColor: const WidgetStatePropertyAll(lightPrimaryColor),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
              side: const WidgetStatePropertyAll(BorderSide.none))),
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
        backgroundColor: lightPrimaryColor,
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(
              color: lightPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold)));

  //-------------------------------------------------
  // Dark Theme
  static const Color darkPrimaryColor = Color(0xFFFACC1D);
  static const Color darkSecondaryColor = Color(0xFF141A2E);
  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      indicatorColor: darkPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: darkPrimaryColor),
      iconTheme: const IconThemeData(color: darkPrimaryColor, size: 30),
      sliderTheme: SliderThemeData(
        trackHeight: 20,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
        activeTrackColor: darkPrimaryColor.withAlpha(178),
        inactiveTrackColor: Colors.grey..withAlpha(125),
        thumbColor: darkPrimaryColor,
        valueIndicatorColor: lightPrimaryColor,
        valueIndicatorTextStyle:
            const TextStyle(color: Colors.white, fontSize: 25),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: Colors.white,
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1.3),
      ),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: darkSecondaryColor,
          showDragHandle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          color: darkSecondaryColor,
          surfaceTintColor: null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      dialogTheme: DialogTheme(
          backgroundColor: darkSecondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      textTheme: TextTheme(
          titleMedium: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: DefinedFontFamilies.elMessiri,
              fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily),
          // for displaying suras and ahadeeth:
          displayLarge: GoogleFonts.notoKufiArabic(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 40)),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: darkPrimaryColor),
        color: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 25,
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
              foregroundColor: const WidgetStatePropertyAll(Colors.black),
              textStyle: WidgetStatePropertyAll(
                  GoogleFonts.ibmPlexSansArabic(fontSize: 20)),
              backgroundColor: const WidgetStatePropertyAll(darkPrimaryColor),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
              side: const WidgetStatePropertyAll(BorderSide.none))),
      buttonTheme: const ButtonThemeData(
        padding: EdgeInsets.all(10),
        shape: ContinuousRectangleBorder(
            side: BorderSide(color: darkPrimaryColor, width: 3)),
      ),
      dividerTheme:
          const DividerThemeData(color: darkPrimaryColor, thickness: 3),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: darkPrimaryColor,
        selectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
            fontSize: 18,
            color: darkPrimaryColor),
        unselectedLabelStyle:
            const TextStyle(fontSize: 0, color: darkSecondaryColor),
        unselectedItemColor: Colors.white,
        backgroundColor: darkSecondaryColor,
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: darkPrimaryColor,
          contentTextStyle: TextStyle(
              color: darkSecondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold)));
}
