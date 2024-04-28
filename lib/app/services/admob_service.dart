// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/env.dart';
import 'package:zippy/app/utils/random.dart';

int PRELOAD_AD_INDEX = 3;

class AdmobService extends GetxService {
  static bool isProduction = ENV.ZIPPY_ENV == production;

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_BANNER_AOS
          : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_BANNER_IOS
          : 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_INTERSTITIAL_AOS
          : "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_INTERSTITIAL_IOS
          : "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_NATIVE_AOS
          : "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_NATIVE_IOS
          : "ca-app-pub-3940256099942544/3986624511";
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
        _loadBannerAd();
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
    adContentCredits.value = randomInt(5, 8);
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

  void _loadBannerAd() {
    BannerAd ad = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();

    bannerAd.value = ad;
  }

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
