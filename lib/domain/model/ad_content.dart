import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/item.dart';

@immutable
class AdContent extends Item {
  final List<NativeAd> nativeAds;
  final BannerAd bannerAd;

  const AdContent({required this.nativeAds, required this.bannerAd})
      : super(isAd: true);

  @override
  List<Object> get props {
    return [...super.props, nativeAds];
  }

  @override
  toJson() => {'isAd': isAd, 'nativeAds': nativeAds};

  @override
  String toString() {
    return toJson().toString();
  }
}
