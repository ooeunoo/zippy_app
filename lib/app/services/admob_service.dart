// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

int DEFAULT_CREDIT = 5;

class AdmobService extends GetxService {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Rx<int> credits = Rx<int>(0);
  Rxn<InterstitialAd> interstitialAd = Rxn<InterstitialAd>();

  @override
  onInit() {
    super.onInit();
    resetCredit();

    ever(credits, (v) {
      print('credit: $v');
      if (v == 0) {
        loadInterstitialAd();
        resetCredit();
      }
    });
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // ad.fullScreenContentCallback = const FullScreenContentCallback();
          interstitialAd.value = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void useCredit() {
    credits.value = credits.value - 1;
  }

  void resetCredit() {
    credits.value = DEFAULT_CREDIT;
  }
}
