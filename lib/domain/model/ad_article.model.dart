import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class AdArticle extends Article {
  final NativeAd nativeAd;

  AdArticle({
    super.sourceId = 0,
    super.title = '',
    super.link = '',
    super.author = '',
    super.images = const [],
    super.summary = '',
    super.keyPoints = const [],
    super.keywords = const [],
    super.attachments = const [],
    super.content = '',
    DateTime? published,
    required this.nativeAd,
    super.isAd = true,
    super.excerpt = '',
  }) : super(published: published ?? DateTime.now());

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
