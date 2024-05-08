import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/content.dart';

@immutable
class AdContent extends Content {
  final NativeAd nativeAd;

  const AdContent({
    super.categoryId = 0,
    super.url = '',
    super.title = '',
    super.author = '',
    super.contentText,
    super.contentImgUrl,
    required this.nativeAd,
    super.isAd = true,
  });

  @override
  List<Object> get props {
    return [
      ...super.props,
      nativeAd,
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'nativeAd': nativeAd,
      };

  @override
  String toString() => toJson().toString();
}
