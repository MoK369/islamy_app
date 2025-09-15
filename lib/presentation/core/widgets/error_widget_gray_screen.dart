import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:lottie/lottie.dart';

class ErrorWidgetReplacingGrayScreen extends StatelessWidget {
  const ErrorWidgetReplacingGrayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.2,
                child: Transform.scale(
                  scale: 1.2,
                  child: Lottie.asset(
                    AssetsPaths.errorOccurredAnimation,
                  ),
                )),
            const SizedBox(
              height: 16,
            ),
            Text(Locales.getTranslations(context).errorOccurred,
                style: theme.textTheme.bodyMedium)
          ],
        ),
      ),
    );
  }
}
