import 'package:flutter/material.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/presentation/core/api_error_message/api_error_message.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';

class CustomErrorWidget extends StatelessWidget {
  final ServerError? serverError;
  final CodeError? codeError;
  final bool showTryAgainButton;
  final VoidCallback? onTryAgainClick;

  const CustomErrorWidget(
      {super.key,
      this.serverError,
      this.codeError,
      this.showTryAgainButton = false,
      this.onTryAgainClick});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                ApiErrorMessage.getErrorMessage(
                    serverError: serverError, codeError: codeError),
                style: theme.textTheme.titleMedium),
            const SizedBox(
              height: 4,
            ),
            if (showTryAgainButton)
              ElevatedButton(
                  onPressed: onTryAgainClick,
                  child: Text(Locales.getTranslations(context).tryAgain))
          ],
        ),
      ),
    );
  }
}
