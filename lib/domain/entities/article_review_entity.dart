import 'package:cocomu/app/enum/community.dart';
import 'package:cocomu/domain/entities/article_review_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_review_entity.freezed.dart';
part 'article_review_entity.g.dart';

@freezed
class ArticleReviewEntity with _$ArticleReviewEntity {
  const factory ArticleReviewEntity({
    required String reviewer,
    required String content,
    required DateTime createdAt,
    List<ArticleReviewEntity>? subReviews,
  }) = _ArticleReviewEntity;

  factory ArticleReviewEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleReviewEntityFromJson(json);
}
