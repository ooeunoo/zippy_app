import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/env.dart';
import 'package:zippy/app/utils/random.dart';

int PRELOAD_CARD_AD_INDEX = 3;

enum NativeFactoryAdId {
  card("cardAd"),
  bottomBanner("bottomBannerAd"),
  ;

  final String value;
  const NativeFactoryAdId(this.value);
}

class AdmobService extends GetxService {
  static String get cardNativeAdUnitId {
    if (Platform.isAndroid) {
      return ENV.GOOGLE_ADMOB_CARD_NATIVE_AOS;
    } else if (Platform.isIOS) {
      return ENV.GOOGLE_ADMOB_CARD_NATIVE_IOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bottomBannerAdUnitId {
    if (Platform.isAndroid) {
      return ENV.GOOGLE_ADMOB_BOTTOM_BANNER_AOS;
    } else if (Platform.isIOS) {
      return ENV.GOOGLE_ADMOB_BOTTOM_BANNER_IOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Rx<int> cardAdCredits = Rx<int>(0).obs();
  Rxn<NativeAd> cardAd = Rxn<NativeAd>().obs();
  Rxn<NativeAd> bottomBannerAd = Rxn<NativeAd>().obs();

  @override
  onInit() {
    super.onInit();
    resetCardAdContent();

    ever(cardAdCredits, (credits) {
      if (credits == PRELOAD_CARD_AD_INDEX) {
        _loadCardNativeAd();
      }
    });
  }

  int useCardAdCredits() {
    if (cardAdCredits.value <= 0) {
      cardAdCredits.value = 0;
    } else {
      cardAdCredits.value = cardAdCredits.value - 1;
    }
    return cardAdCredits.value;
  }

  void resetCardAdContent() {
    cardAdCredits.value = randomInt(5, 8);
  }

  void _loadCardNativeAd() {
    NativeAd ad = _getNativeAdTemplate(NativeFactoryAdId.card)..load();
    cardAd.value = ad;
  }

  void loadBottomBannerNativeAd() {
    NativeAd ad = _getNativeAdTemplate(NativeFactoryAdId.bottomBanner)..load();
    bottomBannerAd.value = ad;
  }

  NativeAd _getNativeAdTemplate(NativeFactoryAdId id) {
    late String adUnitId;
    late String factoryId;

    switch (id) {
      case NativeFactoryAdId.card:
        adUnitId = cardNativeAdUnitId;
        factoryId = "cardAd";
        break;
      case NativeFactoryAdId.bottomBanner:
        adUnitId = bottomBannerAdUnitId;
        factoryId = "bottomBannerAd";
        break;
    }

    return NativeAd(
      adUnitId: adUnitId,
      factoryId: factoryId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (id == NativeFactoryAdId.card) {
            print('Native Card ad loaded successfully');
            cardAd.value = ad as NativeAd;
          } else if (id == NativeFactoryAdId.bottomBanner) {
            print('Native Banner ad loaded successfully');
            bottomBannerAd.value = ad as NativeAd;
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (id == NativeFactoryAdId.card) {
            print('Native Card ad failed to load: $error');
            cardAd.value = null;
          } else if (id == NativeFactoryAdId.bottomBanner) {
            print('Native Banner ad failed to load: $error');
            bottomBannerAd.value = null;
          }
        },
      ),
      request: const AdRequest(),
    );
  }
}
