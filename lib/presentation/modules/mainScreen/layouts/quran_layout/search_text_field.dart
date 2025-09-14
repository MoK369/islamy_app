import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';

class SearchTextField extends StatelessWidget {
  final void Function(String) onChange;

  const SearchTextField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      child: TextField(
        cursorColor: theme.progressIndicatorTheme.color,
        controller: mainScreenProvider.searchFieldController,
        style: theme.textTheme.bodyMedium,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          hintText: Locales.getTranslations(context).search,
          suffixIcon: const Icon(
            Icons.search,
            size: 40,
          ),
        ),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
