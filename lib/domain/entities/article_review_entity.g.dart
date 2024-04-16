// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_review_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleReviewEntityImpl _$$ArticleReviewEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ArticleReviewEntityImpl(
      reviewer: json['reviewer'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subReviews: (json['subReviews'] as List<dynamic>?)
          ?.map((e) => ArticleReviewEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ArticleReviewEntityImplToJson(
        _$ArticleReviewEntityImpl instance) =>
    <String, dynamic>{
      'reviewer': instance.reviewer,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'subReviews': instance.subReviews,
    };
