import 'package:flutter/material.dart';

class CustBottomSheet {
  static void bottomSheetOfSurahAndHadeethFontSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      constraints: BoxConstraints(minWidth: size.width),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return const SizedBox();
      },
    );
  }
}
