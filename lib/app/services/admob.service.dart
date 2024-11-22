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
    cardAdCredits.value = cardAdCredits.value <= 0 ? 0 : cardAdCredits.value - 1;
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
    _loadNativeAd(
      type: NativeAdType.bottomBanner,
      adUnitId: bottomBannerAdUnitId,
      onAdLoaded: (ad) => bottomBannerAd.value = ad,
      onAdFailedToLoad: () {
        bottomBannerAd.value = null;
        _retryLoadBottomBanner();
      },
      onAdClosed: () {
        isAdLoaded.value = false;
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
    final currentAd = type == NativeAdType.card ? cardAd.value : bottomBannerAd.value;
    currentAd?.dispose();

    try {
      final ad = NativeAd(
        adUnitId: adUnitId,
        factoryId: type.factoryId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('${type.name} ad loaded successfully');
            isAdLoaded.value = true;
            onAdLoaded(ad as NativeAd);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('${type.name} ad failed to load: $error');
            ad.dispose();
            isAdLoaded.value = false;
            onAdFailedToLoad();
          },
          onAdClicked: (_) => debugPrint('${type.name} ad clicked'),
          onAdClosed: onAdClosed != null ? (_) => onAdClosed() : null,
          onAdImpression: (_) => debugPrint('${type.name} ad impression recorded'),
        ),
        request: const AdRequest(),
        nativeAdOptions: nativeAdOptions,
      );

      ad.load();
    } catch (e) {
      debugPrint('Exception during ${type.name} ad load: $e');
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
