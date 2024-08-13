import 'package:flutter/material.dart';
import 'package:islamic_app/core/app_locals/locals.dart';
import 'package:islamic_app/core/themes/app_themes.dart';

class SebhaLayout extends StatefulWidget {
  SebhaLayout({super.key});

  @override
  State<SebhaLayout> createState() => _SebhaLayoutState();
}

class _SebhaLayoutState extends State<SebhaLayout> {
  late ThemeData theme;
  late Size size;

  int numberOfTasbeehat = 0, counterOfTasbeeh = 0;
  double rotation = 0;
  String kindOfTesbeeh = "سبحان الله";

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
        Center(
            child: Text(Locals.getTranslations(context).numberOfPraises,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleMedium)),
        SizedBox(
          height: size.height * 0.005,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.2,
              //heightFactor: 0.4,
              child: Card(
                color: theme.cardTheme.color == Colors.white
                    ? Themes.lightPrimaryColor
                    : theme.cardTheme.color,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Text(
                      '$numberOfTasbeehat',
                      style: theme.textTheme.bodyLarge,
                    ),
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
                  onClick();
                },
                child: Text(kindOfTesbeeh),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onClick() {
    setState(() {
      numberOfTasbeehat++;
      rotation += 0.5;
      rotation == 360 ? rotation = 0 : rotation = rotation;
      if (numberOfTasbeehat == 33) {
        counterOfTasbeeh += 1;
        if (counterOfTasbeeh == 4) {
          counterOfTasbeeh = 0;
        }
        numberOfTasbeehat = 0;
      }
      switch (counterOfTasbeeh) {
        case 0:
          kindOfTesbeeh = 'سبحان الله';
          break;
        case 1:
          kindOfTesbeeh = 'الحمد لله';
          break;
        case 2:
          kindOfTesbeeh = 'الله أكبر';
          break;
        case 3:
          kindOfTesbeeh = 'لا إله إلا الله';
          break;
        default:
          kindOfTesbeeh = '';
          break;
      }
    });
  }
}
