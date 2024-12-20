import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/domain/enum/article_category_type.dart';
import 'package:zippy/domain/model/article_cached.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ArticleWithCategoryGroupEntity extends Equatable {
  final Map<ArticleCategoryType, List<ArticleEntity>> result;

  const ArticleWithCategoryGroupEntity({
    required this.result,
  });

  @override
  List<Object> get props {
    return [result];
  }

  factory ArticleWithCategoryGroupEntity.fromJson(Map<String, dynamic> json) {
    Map<ArticleCategoryType, List<ArticleEntity>> categoryMap = {
      ArticleCategoryType.TOP:
          (json['TOP'] as List).map((e) => ArticleEntity.fromJson(e)).toList(),
      ArticleCategoryType.DAILY: (json['DAILY'] as List)
          .map((e) => ArticleEntity.fromJson(e))
          .toList(),
      ArticleCategoryType.WEEKLY: (json['WEEKLY'] as List)
          .map((e) => ArticleEntity.fromJson(e))
          .toList(),
      ArticleCategoryType.MONTHLY: (json['MONTHLY'] as List)
          .map((e) => ArticleEntity.fromJson(e))
          .toList(),
    };

    return ArticleWithCategoryGroupEntity(
      result: categoryMap,
    );
  }

  ArticleWithCategoryGroup toModel() {
    return ArticleWithCategoryGroup(
      result: result.map((key, value) =>
          MapEntry(key, value.map((e) => e.toModel()).toList())),
    );
  }
}
