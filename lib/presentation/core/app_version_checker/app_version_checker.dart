import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:islamy_app/data/models/check_app_version_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/app_version_check/app_version_check_repo.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class AppVersionCheckerViewModel {
  final AppVersionCheckRepo _appVersionCheckRepo;

  AppVersionCheckerViewModel(this._appVersionCheckRepo);

  late StreamSubscription<InternetStatus> _checkAppVersionListener;

  void checkAppVersion() {
    _checkAppVersionListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          debugPrint("The internet is now connected");
          await _checkForUpdate();
          break;
        case InternetStatus.disconnected:
          debugPrint("The internet is now disconnected");
          break;
      }
    });
  }

  Future<void> _checkForUpdate() async {
    var repoResult = await _appVersionCheckRepo.checkForUpdate();

    switch (repoResult) {
      case Success<CheckAppVersionModel>():
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        if (repoResult.data.latestVersion != currentVersion) {
          _checkAppVersionListener.cancel();
          showDialog(
            barrierDismissible: false,
            context: globalNavigatorKey.currentContext!,
            builder: (_) => AlertDialog(
                title: Text(
                  Locales.getTranslations(globalNavigatorKey.currentContext!)
                      .updateAvailable,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                    Locales.getTranslations(globalNavigatorKey.currentContext!)
                        .newVersionMessage("${repoResult.data.latestVersion}")),
                actions: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth / 2) - 5,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await launchUrl(Uri.parse(
                                      repoResult.data.updateUrl ??
                                          "")); // Use url_launcher package
                                },
                                style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2))),
                                child: Text(
                                  Locales.getTranslations(context).update,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth / 2) - 5,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(
                                    globalNavigatorKey.currentContext!),
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2))),
                                child: Text(
                                    Locales.getTranslations(context).later,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  //Spacer()
                ]),
          );
        }
      case ServerError<CheckAppVersionModel>():
        debugPrint("Error checking app version ${repoResult.message}");
      case CodeError<CheckAppVersionModel>():
        debugPrint("Error checking app version ${repoResult.exception}");
    }
  }
}
