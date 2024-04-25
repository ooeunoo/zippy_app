import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/item.dart';

@immutable
class AdContent extends Item {
  final NativeAd nativeAd;

  const AdContent({required this.nativeAd}) : super(isAd: true);

  @override
  List<Object> get props {
    return [...super.props, nativeAd];
  }

  @override
  toJson() => {'isAd': isAd, 'nativeAd': nativeAd};

  @override
  String toString() {
    return toJson().toString();
  }
}
