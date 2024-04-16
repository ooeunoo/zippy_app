// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleEntityImpl _$$ArticleEntityImplFromJson(Map<String, dynamic> json) =>
    _$ArticleEntityImpl(
      community: $enumDecode(_$CommunityEnumMap, json['community']),
      title: json['title'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ArticleReviewEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      numViews: json['numViews'] as int,
      numRecommendations: json['numRecommendations'] as int,
      numReviews: json['numReviews'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ArticleEntityImplToJson(_$ArticleEntityImpl instance) =>
    <String, dynamic>{
      'community': _$CommunityEnumMap[instance.community]!,
      'title': instance.title,
      'author': instance.author,
      'content': instance.content,
      'reviews': instance.reviews,
      'numViews': instance.numViews,
      'numRecommendations': instance.numRecommendations,
      'numReviews': instance.numReviews,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CommunityEnumMap = {
  Community.dcinside: 'dcinside',
  Community.ppomppu: 'ppomppu',
  Community.bobaedream: 'bobaedream',
};
