// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/random.dart';

int PRELOAD_NATIVE_AD_INDEX =
    3; // Must less than DEFAULT_NATIVE_CREDIT min value

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

  Rx<int> intersitialAdCredits = Rx<int>(0).obs();
  Rx<int> adContentCredits = Rx<int>(0).obs();
  Rxn<InterstitialAd> interstitialAd = Rxn<InterstitialAd>().obs();
  RxList<NativeAd> nativeAds = RxList<NativeAd>().obs();
  Rxn<BannerAd> bannerAd = Rxn<BannerAd>().obs();

  @override
  onInit() {
    super.onInit();
    resetAdContent();
    resetIntersitialAdCredits();

    ever(intersitialAdCredits, (credits) {
      if (credits == 0) {
        loadInterstitialAd();
        resetIntersitialAdCredits();
      }
    });

    ever(adContentCredits, (credits) {
      if (credits == PRELOAD_NATIVE_AD_INDEX) {
        loadNativeAd();
        loadBannerAd();
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
    NativeAd ad1 = _getNativeAdTemplate()..load();
    // NativeAd ad2 = _getNativeAdTemplate()..load();
    nativeAds.assignAll([ad1]);
  }

  void loadBannerAd() {
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

  void useIntersitialAdCredits() {
    intersitialAdCredits.value = intersitialAdCredits.value - 1;
  }

  void resetIntersitialAdCredits() {
    intersitialAdCredits.value = randomInt(8, 10);
  }

  int useAdContentCredits() {
    if (adContentCredits.value <= 0) {
      adContentCredits.value = 0;
    } else {
      adContentCredits.value = adContentCredits.value - 1;
    }
    return adContentCredits.value;
  }

  void resetAdContent() {
    nativeAds.value = [];
    bannerAd.value = null;
    adContentCredits.value = randomInt(5, 8);
  }

  (List<NativeAd>, BannerAd) useAdContent() {
    List<NativeAd> nads = nativeAds.value;
    BannerAd bad = bannerAd.value!;
    resetAdContent();
    return (nads, bad);
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
                backgroundColor: AppColor.rose700,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColor.graymodern600,
                backgroundColor: AppColor.cyan700,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)));
  }
}
