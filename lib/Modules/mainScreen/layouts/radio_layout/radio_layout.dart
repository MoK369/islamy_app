import 'package:flutter/material.dart';
import 'package:islamic_app/core/app_locals/locals.dart';

class RadioLayout extends StatelessWidget {
  RadioLayout({super.key});

  late ThemeData theme;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FractionallySizedBox(
            widthFactor: 0.9,
            child: Image.asset('assets/images/radio_image.png')),
        Center(
            child: Text(
          Locals.getTranslations(context).holyQuranRadio,
          style: theme.textTheme.titleMedium,
        )),
        SizedBox(
          height: size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              splashColor: Colors.grey,
              onTap: () {},
              child: ImageIcon(
                const AssetImage('assets/icons/icon_previous.png'),
                size: size.width * 0.1,
              ),
            ),
            InkWell(
              splashColor: Colors.grey,
              onTap: () {},
              child: ImageIcon(
                const AssetImage('assets/icons/icon-play.png'),
                size: size.width * 0.1,
              ),
            ),
            InkWell(
                splashColor: Colors.grey,
                onTap: () {},
                child: ImageIcon(
                  const AssetImage('assets/icons/icon_next.png'),
                  size: size.width * 0.1,
                ))
          ],
        )
      ],
    );
  }
}
