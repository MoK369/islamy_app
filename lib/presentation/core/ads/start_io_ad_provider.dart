import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:startapp_sdk/startapp.dart';

@injectable
class StartIoAdProvider extends ChangeNotifier {
  static StartAppSdk startAppSdk = StartAppSdk();

  bool isInterstitialAdShowedOnce = false;
  late StreamSubscription<InternetStatus> showBannerListener;
  late StreamSubscription<InternetStatus> showInterstitialListener;
  StartAppBannerAd? startAppBannerAd;
  StartAppInterstitialAd? startAppInterstitialAd;

  Future<void> initialize() async {
    startAppSdk.setTestAdsEnabled(kReleaseMode ? false : true);
  }

  Future<void> showBannerAd() async {
    showBannerListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          debugPrint("The internet is now connected");
          debugPrint("inside listener of Banner ========== ");
          await startAppSdk
              .loadBannerAd(StartAppBannerType.BANNER)
              .then((bannerAd) {
            startAppBannerAd = bannerAd;
            notifyListeners();
          }).onError<StartAppException>((ex, stackTrace) {
            debugPrint("Error loading Banner ad: ${ex.message}");
          }).onError((error, stackTrace) {
            debugPrint("Error loading Banner ad: $error");
          });
          break;
        case InternetStatus.disconnected:
          debugPrint("The internet is now disconnected");
          break;
      }
    });
  }

  Future<void> showInterstitialAd() async {
    showInterstitialListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          debugPrint("The internet is now connected");
          debugPrint("inside listener of Interstitial ========== ");
          await startAppSdk.loadInterstitialAd().then((interstitialAd) {
            startAppInterstitialAd = interstitialAd;
            notifyListeners();
          }).onError<StartAppException>((ex, stackTrace) {
            debugPrint("Error loading Interstitial ad: ${ex.message}");
          }).onError((error, stackTrace) {
            debugPrint("Error loading Interstitial ad: $error");
          });
          break;
        case InternetStatus.disconnected:
          debugPrint("The internet is now disconnected");
          break;
      }
    });
  }
}
