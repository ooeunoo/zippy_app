import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/utils/env.dart';
import 'package:zippy/app/utils/random.dart';

const int PRELOAD_CARD_AD_INDEX = 5;

enum NativeAdType {
  card('cardAd'),
  bottomBanner('bottomBannerAd');

  final String factoryId;
  const NativeAdType(this.factoryId);
}

class AdmobService extends GetxService {
  static String _getAdUnitId(String androidId, String iosId) {
    if (Platform.isAndroid) {
      return androidId;
    } else if (Platform.isIOS) {
      return iosId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get cardNativeAdUnitId => _getAdUnitId(
        ENV.GOOGLE_ADMOB_CARD_NATIVE_AOS,
        ENV.GOOGLE_ADMOB_CARD_NATIVE_IOS,
      );

  static String get bottomBannerAdUnitId => _getAdUnitId(
        ENV.GOOGLE_ADMOB_BOTTOM_BANNER_AOS,
        ENV.GOOGLE_ADMOB_BOTTOM_BANNER_IOS,
      );

  final cardAdCredits = 0.obs;
  final cardAd = Rxn<NativeAd>();
  final bottomBannerAd = Rxn<NativeAd>();
  final isAdLoaded = false.obs;
  final isBottomBannerAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetCardAdContent();
    _setupCardAdPreload();
  }

  void _setupCardAdPreload() {
    ever(cardAdCredits, (credits) {
      if (credits == PRELOAD_CARD_AD_INDEX) {
        loadCardNativeAd();
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
    cardAdCredits.value =
        cardAdCredits.value <= 0 ? 0 : cardAdCredits.value - 1;
    return cardAdCredits.value;
  }

  void resetCardAdContent() {
    cardAdCredits.value = randomInt(8, 10);
    cardAd.value = null;
  }

  void loadCardNativeAd() {
    _loadNativeAd(
      type: NativeAdType.card,
      adUnitId: cardNativeAdUnitId,
      onAdLoaded: (ad) => cardAd.value = ad,
      onAdFailedToLoad: () => cardAd.value = null,
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.any,
        videoOptions: VideoOptions(
          clickToExpandRequested: true,
          customControlsRequested: true,
          startMuted: true,
        ),
      ),
    );
  }

  void loadBottomBannerNativeAd() {
    // Dispose existing ad if any
    bottomBannerAd.value?.dispose();
    bottomBannerAd.value = null;
    isBottomBannerAdLoaded.value = false;

    _loadNativeAd(
      type: NativeAdType.bottomBanner,
      adUnitId: bottomBannerAdUnitId,
      onAdLoaded: (ad) async {
        // Ensure the ad is loaded before setting values
        bottomBannerAd.value = ad;
        // Set loaded flag after ad is available
        isBottomBannerAdLoaded.value = true;
      },
      onAdFailedToLoad: () {
        bottomBannerAd.value?.dispose();
        bottomBannerAd.value = null;
        isBottomBannerAdLoaded.value = false;
        _retryLoadBottomBanner();
      },
      onAdClosed: () {
        isBottomBannerAdLoaded.value = false;
        loadBottomBannerNativeAd();
      },
    );
  }

  void _loadNativeAd({
    required NativeAdType type,
    required String adUnitId,
    required Function(NativeAd) onAdLoaded,
    required Function() onAdFailedToLoad,
    Function()? onAdClosed,
    NativeAdOptions? nativeAdOptions,
  }) {
    try {
      final ad = NativeAd(
        adUnitId: adUnitId,
        factoryId: type.factoryId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
            onAdLoaded(ad as NativeAd);
          },
          onAdFailedToLoad: (ad, error) {
            print('Failed to load ${type.name} ad: $error');
            ad.dispose();
            isAdLoaded.value = false;
            onAdFailedToLoad();
          },
          onAdClosed: onAdClosed != null ? (_) => onAdClosed() : null,
        ),
        request: const AdRequest(),
        nativeAdOptions: nativeAdOptions,
      );

      // Start loading the ad
      ad.load();
    } catch (e, stackTrace) {
      print('Error loading ${type.name} ad: $e\nStack trace: $stackTrace');
      onAdFailedToLoad();
    }
  }

  void _retryLoadBottomBanner() {
    Future.delayed(const Duration(seconds: 30), () {
      if (!isAdLoaded.value) {
        loadBottomBannerNativeAd();
      }
    });
  }
}
