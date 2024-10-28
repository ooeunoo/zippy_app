import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class AdContent extends Article {
  final NativeAd nativeAd;

  const AdContent({
    super.sourceId = 0,
    super.title = '',
    super.subtitle = '',
    super.link = '',
    super.author = '',
    super.content = '',
    super.formattedContent = '',
    super.images = const [],
    super.tags = '',
    super.summary = '',
    super.chatConversation = '',
    super.embedding = '',
    super.attachments = '',
    super.keyPoints = '',
    super.keywords = '',
    super.keywordsEn = '',
    super.topic = '',
    super.terms = '',
    super.published = '',
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
