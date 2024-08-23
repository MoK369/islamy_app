import 'package:flutter/material.dart';
import 'package:islamy_app/core/app_locals/locales.dart';

class RadioLayout extends StatelessWidget {
  const RadioLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
            height: (size.width * 0.7) * (111 / 206),
            width: size.width * 0.7,
            child: Image.asset('assets/images/radio_image.png')),
        Center(
            child: Text(
          Locales.getTranslations(context).holyQuranRadio,
          style: theme.textTheme.titleMedium,
        )),
        SizedBox(
          height: size.height * 0.05,
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
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
          ),
        )
      ],
    );
  }
}
