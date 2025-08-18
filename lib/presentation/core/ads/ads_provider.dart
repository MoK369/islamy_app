import 'package:flutter/foundation.dart';

abstract class AdsProvider extends ChangeNotifier {
  bool isInitializationFinished = false;
  bool isBannerAdShown = false;

  bool isInterstitialAdShowedOnce = false;

  Future<void> initialize();

  Future<void> showBannerAd();

  Future<void> hideBannerAd();

  Future<void> showInterstitialAd();
}
