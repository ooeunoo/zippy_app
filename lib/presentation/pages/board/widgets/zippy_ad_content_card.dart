import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/domain/model/ad_content.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ZippyAdContentCard extends StatelessWidget {
  final AdContent content;

  const ZippyAdContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacerV(value: AppDimens.height(150)),
            Expanded(child: nativeAdSection(content.nativeAds[0])),
            // Expanded(child: nativeAdSection(content.nativeAds[1])),
            // AppSpacerV(value: AppDimens.height(150)),
            SizedBox(
              width: content.bannerAd.size.width.toDouble(),
              height: content.bannerAd.size.height.toDouble(),
              child: AdWidget(ad: content.bannerAd),
            )
          ],
        ),
      ),
    );
  }

  Widget nativeAdSection(NativeAd nativeAd) {
    return AdWidget(ad: nativeAd);
  }
}
