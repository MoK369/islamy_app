import 'package:flutter/material.dart';

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
        textDirection: TextDirection.rtl,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6),
          hintText: "Search",
          hintStyle: theme.textTheme.bodyMedium,
          suffixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.primaryColor)),
        ),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
