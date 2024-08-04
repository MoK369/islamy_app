import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';

class HadeethLayout extends StatefulWidget {
  HadeethLayout({super.key});

  @override
  State<HadeethLayout> createState() => _HadeethLayoutState();
}

class _HadeethLayoutState extends State<HadeethLayout> {
  late ThemeData theme;

  late String hadeeths;

  late List<String> hadeethsList;

  List<String> hadeethsTitle = [];

  @override
  Widget build(BuildContext context) {
    if (hadeethsTitle.isEmpty) {
      readHadeeth();
    }
    theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FractionallySizedBox(
            widthFactor: 0.55,
            child: Image.asset('assets/images/hadith_header.png')),
        const Divider(),
        Text(
          "الأحاديث",
          style: theme.textTheme.bodyLarge,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: hadeethsTitle.length,
            itemBuilder: (context, index) {
              return TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HadeethScreen.routeName,
                        arguments: SendInfo(
                            hadeethTitle: hadeethsTitle[index],
                            hadeethBody: hadeethsList[index]));
                  },
                  child: Text(
                    hadeethsTitle[index],
                    style: theme.textTheme.bodyLarge,
                  ));
            },
          ),
        )
      ],
    );
  }

  void readHadeeth() async {
    hadeeths = await rootBundle.loadString('assets/hadeeths/ahadeth.txt');
    hadeethsList = hadeeths.trim().split('#');
    setState(() {
      for (int i = 0; i < hadeethsList.length; i++) {
        hadeethsTitle.add(hadeethsList[i].trim().split('\n')[0]);
      }
    });
  }
}

class SendInfo {
  String hadeethTitle;
  String hadeethBody;

  SendInfo({required this.hadeethTitle, required this.hadeethBody});
}
