import 'package:cocomu/app/enum/community.dart';
import 'package:cocomu/domain/entities/article_review_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_entity.freezed.dart';
part 'article_entity.g.dart';

@freezed
class ArticleEntity with _$ArticleEntity {
  const factory ArticleEntity({
    required Community community,
    required String title,
    required String author,
    required String content,
    List<ArticleReviewEntity>? reviews,
    required int numViews,
    required int numRecommendations,
    required int numReviews,
    required DateTime createdAt,
  }) = _ArticleEntity;

  factory ArticleEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleEntityFromJson(json);
}
