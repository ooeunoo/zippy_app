// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/env.dart';
import 'package:zippy/app/utils/random.dart';

int PRELOAD_AD_INDEX = 4;

class AdmobService extends GetxService {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return ENV.GOOGLE_ADMOB_PROD_BANNER_AOS;
    } else if (Platform.isIOS) {
      return ENV.GOOGLE_ADMOB_PROD_BANNER_IOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return ENV.GOOGLE_ADMOB_PROD_INTERSTITIAL_AOS;
    } else if (Platform.isIOS) {
      return ENV.GOOGLE_ADMOB_PROD_INTERSTITIAL_IOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return ENV.GOOGLE_ADMOB_PROD_NATIVE_AOS;
    } else if (Platform.isIOS) {
      return ENV.GOOGLE_ADMOB_PROD_NATIVE_IOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Rx<int> intersitialAdCredits = Rx<int>(0).obs();
  Rx<int> adContentCredits = Rx<int>(0).obs();
  Rxn<InterstitialAd> interstitialAd = Rxn<InterstitialAd>().obs();
  Rxn<NativeAd> nativeAd = Rxn<NativeAd>().obs();
  Rxn<BannerAd> bannerAd = Rxn<BannerAd>().obs();

  @override
  onInit() {
    super.onInit();
    print("OnInit");
    resetAdContent();
    resetIntersitialAdCredits();

    ever(intersitialAdCredits, (credits) {
      if (credits == PRELOAD_AD_INDEX) {
        _loadInterstitialAd();
      }
    });

    ever(adContentCredits, (credits) {
      if (credits == PRELOAD_AD_INDEX) {
        _loadNativeAd();
      }
    });
  }

  int useIntersitialAdCredits() {
    if (intersitialAdCredits.value <= 0) {
      intersitialAdCredits.value = 0;
    } else {
      intersitialAdCredits.value = intersitialAdCredits.value - 1;
    }
    return intersitialAdCredits.value;
  }

  int useAdContentCredits() {
    if (adContentCredits.value <= 0) {
      adContentCredits.value = 0;
    } else {
      adContentCredits.value = adContentCredits.value - 1;
    }
    return adContentCredits.value;
  }

  void resetIntersitialAdCredits() {
    intersitialAdCredits.value = randomInt(5, 8);
  }

  void resetAdContent() {
    adContentCredits.value = randomInt(4, 7);
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd.value = ad;
        },
        onAdFailedToLoad: (err) {
          interstitialAd.value = null;
        },
      ),
    );
  }

  void _loadNativeAd() {
    NativeAd ad = _getNativeAdTemplate()..load();
    nativeAd.value = ad;
  }

  void loadBannerAd() async {
    // Get the size before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(Get.context!).width.truncate());

    if (size == null) {
      // Unable to get the size.
      return;
    }

    // Create an extra parameter that aligns the bottom of the expanded ad to the
    // bottom of the banner ad.
    const adRequest = AdRequest(extras: {
      "collapsible": "bottom",
    });

    BannerAd ad = BannerAd(
        adUnitId: bannerAdUnitId,
        request: adRequest,
        size: size,
        listener: const BannerAdListener())
      ..load();
    bannerAd.value = ad;
  }

  // void loadBannerAd() async {
  //   final width = MediaQuery.of(Get.context!).size.width.truncate();

  //   BannerAd ad = BannerAd(
  //     adUnitId: bannerAdUnitId,
  //     request: const AdRequest(),
  //     size: AdSize(width: width, height: AppDimens.height(40).toInt()),
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {},
  //       onAdFailedToLoad: (ad, err) {
  //         print('err: $err');
  //         ad.dispose();
  //       },
  //     ),
  //   )..load();

  //   bannerAd.value = ad;
  // }

  NativeAd _getNativeAdTemplate() {
    return NativeAd(
        adUnitId: nativeAdUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: AppColor.white,
            cornerRadius: AppDimens.size(12),
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.gray100,
                backgroundColor: AppColor.brand600,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern600,
                backgroundColor: AppColor.white,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern600,
                backgroundColor: AppColor.white,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern600,
                backgroundColor: AppColor.white,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)));
  }
}
