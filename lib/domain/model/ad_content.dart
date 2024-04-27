import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/item.dart';

@immutable
class AdContent extends Item {
  final NativeAd nativeAd;
  final BannerAd bannerAd;

  const AdContent({required this.nativeAd, required this.bannerAd})
      : super(isAd: true);

  @override
  List<Object> get props {
    return [...super.props, nativeAd, bannerAd];
  }

  @override
  toJson() => {'isAd': isAd, 'nativeAd': nativeAd, 'bannerAd': bannerAd};

  @override
  String toString() {
    return toJson().toString();
  }
}
