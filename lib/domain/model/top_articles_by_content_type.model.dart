import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class TopArticlesByContentType extends Equatable {
  final int contentTypeId;
  final String contentTypeName;
  final List<Article> articles;

  const TopArticlesByContentType({
    required this.contentTypeId,
    required this.contentTypeName,
    required this.articles,
  });

  @override
  List<Object> get props {
    return [
      contentTypeId,
      contentTypeName,
      articles,
    ];
  }

  Map<String, dynamic> toJson() => {
        'content_type_id': contentTypeId,
        'content_type_name': contentTypeName,
        'articles': articles.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => toJson().toString();
}
