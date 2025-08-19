import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:startapp_sdk/startapp.dart';

@injectable
class StartIoAdProvider extends ChangeNotifier {
  static StartAppSdk startAppSdk = StartAppSdk();
  StartAppBannerAd? startAppBannerAd;
  StartAppInterstitialAd? startAppInterstitialAd;

  Future<void> initialize() async {
    startAppSdk.setTestAdsEnabled(kReleaseMode ? false : true);
  }

  Future<void> showBannerAd() async {
    await startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
      startAppBannerAd = bannerAd;
      notifyListeners();
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });
  }

  Future<void> showInterstitialAd() async {
    await startAppSdk.loadInterstitialAd().then((interstitialAd) {
      startAppInterstitialAd = interstitialAd;
      notifyListeners();
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }
}
