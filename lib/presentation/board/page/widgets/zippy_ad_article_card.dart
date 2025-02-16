import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/ad_article.model.dart';

class ZippyAdArticleCard extends StatelessWidget {
  final AdArticle adArticle;

  const ZippyAdArticleCard({
    Key? key,
    required this.adArticle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdWidget(ad: adArticle.nativeAd),
    );
  }
}
