import 'package:flutter/material.dart';
import 'package:islamic_app/core/widgets/background_container.dart';

import '../../../../core/app_locals/locales.dart';
import 'hadeeth_layout.dart';

class HadeethScreen extends StatelessWidget {
  static const String routeName = 'HadeethScreen';

  const HadeethScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HadethData args = ModalRoute.of(context)!.settings.arguments as HadethData;
    ThemeData theme = Theme.of(context);
    return SafeArea(
        child: BgContainer(
            child: Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.getTranslations(context).islami,
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
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,
          heightFactor: 0.9,
          child: Card(
            child: Column(
              children: [
                Text(
                  args.hadeethTitle,
                  style: theme.textTheme.titleMedium,
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
                      style: theme.textTheme.displayLarge,
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
