import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamic_app/Modules/mainScreen/main_screen.dart';
import 'package:islamic_app/core/app_locals/locals.dart';

class HadeethLayout extends StatefulWidget {
  HadeethLayout({super.key});

  @override
  State<HadeethLayout> createState() => _HadeethLayoutState();
}

class _HadeethLayoutState extends State<HadeethLayout> {
  late ThemeData theme;
  List<HadethData> ahadeeth = [];
  @override
  Widget build(BuildContext context) {
    if (ahadeeth.isEmpty) {
      readHadeeth();
    }
    theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/hadith_header.png',
          height: MainScreenState.screenSize.height * 0.2,
        ),
        const Divider(),
        Text(
          Locals.getLocals(context).ahadeeth,
          style: theme.textTheme.bodyLarge,
        ),
        const Divider(),
        Expanded(
            child: ahadeeth.isEmpty
                ? CircularProgressIndicator(
                    color: theme.primaryColor,
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ahadeeth.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, HadeethScreen.routeName,
                                arguments: ahadeeth[index]);
                          },
                          child: Text(
                            ahadeeth[index].hadeethTitle,
                            style: theme.textTheme.bodyLarge,
                          ));
                    },
                  ))
      ],
    );
  }

  void readHadeeth() async {
    String hadeeths =
        await rootBundle.loadString('assets/hadeeths/ahadeth.txt');
    List<String> eachHadeethList = hadeeths.trim().split('#');
    setState(() {
      for (int i = 0; i < eachHadeethList.length; i++) {
        List<String> singleHadeeth = eachHadeethList[i].trim().split('\n');
        String hadethTitle = singleHadeeth[0];
        singleHadeeth.removeAt(0);
        String hadeethBody = singleHadeeth.join(' ');
        HadethData h =
            HadethData(hadeethTitle: hadethTitle, hadeethBody: hadeethBody);
        ahadeeth.add(h);
      }
    });
  }
}

class HadethData {
  String hadeethTitle;
  String hadeethBody;

  HadethData({required this.hadeethTitle, required this.hadeethBody});
}
