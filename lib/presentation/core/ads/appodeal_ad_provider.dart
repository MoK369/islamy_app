import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/ads/ads_provider.dart';
import 'package:islamy_app/presentation/core/ads/constants.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

@Named(AdsConstants.appodealAdsProvider)
@LazySingleton(as: AdsProvider)
class AppodealAdsProvider extends AdsProvider {
  @override
  Future<void> initialize() async {
    try {
      Appodeal.setTesting(false); //only not release mode
      Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
      Appodeal.setAutoCache(AppodealAdType.Interstitial, false);
      Appodeal.setAutoCache(AppodealAdType.RewardedVideo, false);
      Appodeal.setUseSafeArea(true);
      Appodeal.setAdRevenueCallbacks(onAdRevenueReceive: (adRevenue) {
        debugPrint("onAdRevenueReceive: $adRevenue");
      });
      Appodeal.initialize(
        appKey: AdsConstants.appodealAndroidKey,
        adTypes: [
          //AppodealAdType.RewardedVideo,
          AppodealAdType.Interstitial,
          AppodealAdType.Banner,
          //AppodealAdType.MREC
        ],
        onInitializationFinished: (errors) {
          errors?.forEach((error) => debugPrint(error.description));
          debugPrint(
              "onInitializationFinished: errors - ${errors?.length ?? 0}");
          if (errors?.length == null || errors!.isEmpty) {
            isInitializationFinished = true;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint("Error initializing Appodeal: ${e.toString()}");
    }
  }

  @override
  Future<void> showBannerAd() async {
    int count = 0;
    if (!isBannerAdShown) {
      bool isBannerInitialized =
          await Appodeal.isInitialized(AppodealAdType.Banner);
      if (isBannerInitialized) {
        bool isCanShow = await Appodeal.canShow(AppodealAdType.Banner);
        if (isCanShow) {
          isBannerAdShown = await Appodeal.show(AppodealAdType.BannerTop);
        } else {
          debugPrint("Can't show Banner");
          if (count < 1) {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                showBannerAd();
                count++;
              },
            );
          }
        }
      } else {
        debugPrint("Banner isn't initialized");
      }
    }
  }

  @override
  Future<void> hideBannerAd() async {
    Appodeal.hide(AppodealAdType.Banner);
    isBannerAdShown = false;
  }

  @override
  Future<void> showInterstitialAd() async {
    int count = 0;
    if (!isInterstitialAdShowedOnce) {
      bool isInitialized =
          await Appodeal.isInitialized(AppodealAdType.Interstitial);
      if (isInitialized) {
        Appodeal.cache(AppodealAdType.Interstitial);
        bool isCanShow = await Appodeal.canShow(AppodealAdType.Interstitial);
        if (isCanShow) {
          isInterstitialAdShowedOnce =
              await Appodeal.show(AppodealAdType.Interstitial);
        } else {
          debugPrint("Can't show Interstitial");
          if (count < 1) {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                showInterstitialAd();
                count++;
              },
            );
          }
        }
      } else {
        debugPrint("Interstitial isn't initialized");
      }
    }
  }
}
