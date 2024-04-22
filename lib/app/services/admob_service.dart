import 'dart:io';

import 'package:cocomu/app/utils/env.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService extends GetxService {
  static AdmobService get to => Get.find();
  // TEST ADMOB

  final String aosTestUnitId = ENV.GOOGLE_ADMOB_DEV_BANNER_AOS;
  final String iosTestUnitId = ENV.GOOGLE_ADMOB_DEV_BANNER_IOS;

  late BannerAd banner;
  RxBool isBannerReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    initBanner();
  }

  void initBanner() {
    print("initBanner");
    String targetUnitId = Platform.isIOS ? iosTestUnitId : aosTestUnitId;
    BannerAd banner = BannerAd(
      size: AdSize.banner,
      adUnitId: targetUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerReady(true);
          print("ready true");
        },
        onAdFailedToLoad: (ad, error) {
          print(ad.toString());

          print(error);

          isBannerReady(false);
          print("ready false");
        },
      ),
    )..load();
    banner = banner;
  }
}
