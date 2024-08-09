import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';

class SearchTextField extends StatelessWidget {
  void Function(String) onChange;

  SearchTextField({super.key, required this.onChange});
  late ThemeData theme;
  late Size size;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      child: TextField(
        controller: QuranLayoutState.searchFieldController,
        textDirection: TextDirection.rtl,
        style: theme.textTheme.bodyMedium,
        decoration: const InputDecoration(
          hintText: "البحث",
          hintTextDirection: TextDirection.rtl,
          suffixIcon: Icon(
            Icons.search,
            size: 35,
          ),
        ),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
