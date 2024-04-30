import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/content.dart';

@immutable
class AdContent extends Content {
  final NativeAd nativeAd;
  final BannerAd bannerAd;

  const AdContent({
    super.categoryId = 0,
    super.url = '',
    super.title = '',
    super.itemIndex = 0,
    super.author = '',
    super.contentText,
    super.contentImgUrl,
    required this.nativeAd,
    required this.bannerAd,
    super.isAd = true,
  });

  @override
  List<Object> get props {
    return [...super.props, nativeAd, bannerAd];
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'nativeAd': nativeAd,
        'bannerAd': bannerAd,
      };

  @override
  String toString() => toJson().toString();
}
