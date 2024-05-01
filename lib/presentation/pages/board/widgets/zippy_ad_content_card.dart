import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/domain/model/ad_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ZippyAdContentCard extends StatefulWidget {
  final AdContent content;

  const ZippyAdContentCard({super.key, required this.content});

  @override
  State<ZippyAdContentCard> createState() => _ZippyAdContentCardState();
}

class _ZippyAdContentCardState extends State<ZippyAdContentCard> {
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
            Expanded(child: nativeAdSection(widget.content.nativeAd)),
            AppSpacerV(value: AppDimens.height(150)),
          ],
        ),
      ),
    );
  }

  Widget nativeAdSection(NativeAd nativeAd) {
    return AdWidget(ad: nativeAd);
  }
}
