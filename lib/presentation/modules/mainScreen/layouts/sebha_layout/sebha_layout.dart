import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/themes/app_themes.dart';

class SebhaLayout extends StatefulWidget {
  const SebhaLayout({super.key});

  @override
  State<SebhaLayout> createState() => _SebhaLayoutState();
}

class _SebhaLayoutState extends State<SebhaLayout> {
  late ThemeData theme;
  late Size size;

  int numberOfTasbeehat = 0, indexOfTasbeeh = 0;
  double rotation = 0;
  String kindOfTesbeeh = "سبحان الله";
  final List<String> tasbeehatList = [
    "سبحان الله",
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر'
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: size.height * 0.4,
          child: GestureDetector(
            onTap: () {
              onSebhaClick();
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Transform.rotate(
                  angle: rotation,
                  child: ImageIcon(
                    const AssetImage('assets/icons/body_of_sebha.png'),
                    size: (size.height * 0.4),
                  ),
                ),
                Positioned(
                  top: -(size.height * 0.4) * 0.05,
                  child: ImageIcon(
                    const AssetImage('assets/icons/head_of_sebha.png'),
                    size: size.height * 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
            child: Text(Locales.getTranslations(context).numberOfPraises,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleMedium)),
        SizedBox(
          height: size.height * 0.005,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.11,
              width: (size.height * 0.11) * (69 / 81),
              child: Card(
                color: theme.cardTheme.color == Colors.white
                    ? Themes.lightPrimaryColor
                    : theme.cardTheme.color,
                child: Center(
                  child: Text(
                    '$numberOfTasbeehat',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: ElevatedButton(
                onPressed: () {
                  onSebhaClick();
                },
                child: Text(kindOfTesbeeh),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onSebhaClick() {
    setState(() {
      numberOfTasbeehat++;
      rotation += 0.5;
      rotation == 360 ? rotation = 0 : rotation = rotation;
      if (numberOfTasbeehat > 33) {
        indexOfTasbeeh += 1;
        if (indexOfTasbeeh == tasbeehatList.length) {
          indexOfTasbeeh = 0;
        }
        numberOfTasbeehat = 0;
      }
      kindOfTesbeeh = tasbeehatList[indexOfTasbeeh];
    });
  }
}
