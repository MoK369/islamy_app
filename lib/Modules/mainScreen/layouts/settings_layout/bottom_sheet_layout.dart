import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  Size screenSize;
  ThemeData theme;
  String text1;
  String text2;
  void Function() function1, function2;

  BottomSheetLayout(
      {super.key,
      required this.screenSize,
      required this.theme,
      required this.text1,
      required this.text2,
      required this.function1,
      required this.function2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.height * 0.4,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: function1,
              child: Text(
                text1,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            MaterialButton(
              onPressed: function2,
              child: Text(
                text2,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
