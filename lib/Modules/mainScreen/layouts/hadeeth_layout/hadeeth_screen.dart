import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/core/widgets/background_container.dart';

import 'hadeeth_layout.dart';

class HadeethScreen extends StatelessWidget {
  static const String routeName = 'HadeethScreen';

  HadeethScreen({super.key});

  late ThemeData theme;
  late HadethData args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as HadethData;
    theme = Theme.of(context);
    return SafeArea(
        child: BgContainer(
            child: Scaffold(
      appBar: AppBar(
        title: Text(
          "إسلامي",
          style: theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 40,
          ),
          color: theme.primaryColor,
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.9,
          child: Container(
            decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                Text(
                  args.hadeethTitle,
                  style: theme.textTheme.bodyLarge,
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      args.hadeethBody,
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.amiriQuran().fontFamily),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
