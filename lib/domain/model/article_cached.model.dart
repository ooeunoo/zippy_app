import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/article_category_type.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class ArticleWithCategoryGroup extends Equatable {
  final Map<ArticleCategoryType, List<Article>> result;

  const ArticleWithCategoryGroup({
    required this.result,
  });

  @override
  List<Object> get props {
    return [result];
  }

  dynamic toJson() => {
        'result': result,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
