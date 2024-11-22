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

  Rx<int> cardAdCredits = Rx<int>(0);
  Rxn<NativeAd> cardAd = Rxn<NativeAd>();
  Rxn<NativeAd> bottomBannerAd = Rxn<NativeAd>();
  final isAdLoaded = false.obs;

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

  @override
  void onClose() {
    cardAd.value?.dispose();
    bottomBannerAd.value?.dispose();
    super.onClose();
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
    print('Starting to load bottom banner ad...');

    // 기존 광고가 있다면 dispose
    bottomBannerAd.value?.dispose();

    try {
      final ad = NativeAd(
        adUnitId: bottomBannerAdUnitId,
        factoryId: 'bottomBannerAd',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('Native Banner ad loaded successfully');
            if (!isAdLoaded.value) {
              bottomBannerAd.value = ad as NativeAd;
              isAdLoaded.value = true;
            }
          },
          onAdFailedToLoad: (ad, error) {
            print('Native Banner ad failed to load: $error');
            ad.dispose();
            bottomBannerAd.value = null;
            isAdLoaded.value = false;
            // 재시도 로직
            Future.delayed(const Duration(seconds: 30), () {
              if (!isAdLoaded.value) {
                loadBottomBannerNativeAd();
              }
            });
          },
          onAdOpened: (ad) => print('Native Banner ad opened'),
          onAdClosed: (ad) {
            print('Native Banner ad closed');
            isAdLoaded.value = false;
            loadBottomBannerNativeAd(); // 광고가 닫히면 새로 로드
          },
          onAdImpression: (ad) => print('Native Banner ad impression recorded'),
        ),
        request: const AdRequest(),
      );

      print('Attempting to load ad...');
      ad.load().then((_) {
        print('Ad load completed');
      }).catchError((error) {
        print('Ad load error: $error');
      });
    } catch (e) {
      print('Exception during ad load: $e');
    }
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
            Future.delayed(Duration(minutes: 1), () {
              loadBottomBannerNativeAd();
            });
          }
        },
        onAdOpened: (ad) => print('Native Banner ad opened'),
        onAdClosed: (ad) => print('Native Banner ad closed'),
        // 광고가 impression 되었는지 확인
        onAdImpression: (ad) => print('Native Banner ad impression recorded'),
      ),
      request: const AdRequest(),
    );
  }
}
