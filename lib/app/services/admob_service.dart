// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';

int DEFAULT_INTERSTIAL_CREDIT = 2;
int DEFAULT_NATIVE_CREDIT = 4;

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

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3986624511";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Rx<int> intersitialAdCredits = Rx<int>(0);
  Rx<int> nativeAdCredits = Rx<int>(0);
  Rxn<InterstitialAd> interstitialAd = Rxn<InterstitialAd>();
  Rxn<NativeAd> nativeAd = Rxn<NativeAd>();

  @override
  onInit() {
    super.onInit();
    resetNativeAd();
    resetIntersitialAdCredits();

    ever(intersitialAdCredits, (credits) {
      if (credits == 0) {
        loadInterstitialAd();
        resetIntersitialAdCredits();
      }
    });

    ever(nativeAdCredits, (credits) {
      print(credits);
      if (credits == 0) {
        loadNativeAd();
      }
    });
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd.value = ad;
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }

  void loadNativeAd() {
    NativeAd ad = NativeAd(
        adUnitId: nativeAdUnitId,
        // factoryId: 'adFactoryExample',
        listener: NativeAdListener(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: AppColor.graymodern950,
            // cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern100,
                backgroundColor: AppColor.graymodern950,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern100,
                backgroundColor: AppColor.graymodern950,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern100,
                backgroundColor: AppColor.graymodern950,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern100,
                backgroundColor: AppColor.graymodern950,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
    nativeAd.value = ad;
  }

  void useIntersitialAdCredits() {
    intersitialAdCredits.value = intersitialAdCredits.value - 1;
  }

  void resetIntersitialAdCredits() {
    intersitialAdCredits.value = DEFAULT_INTERSTIAL_CREDIT;
  }

  void useNativeAdCredits() {
    if (nativeAdCredits.value <= 0) {
      nativeAdCredits.value = 0;
    } else {
      nativeAdCredits.value = nativeAdCredits.value - 1;
    }
  }

  void resetNativeAd() {
    nativeAd.value = null;
    nativeAdCredits.value = DEFAULT_NATIVE_CREDIT;
  }

  NativeAd? useNativeAd() {
    if (nativeAd.value != null) {
      NativeAd ad = nativeAd.value!;
      resetNativeAd();
      return ad;
    }
    return null;
  }
}
