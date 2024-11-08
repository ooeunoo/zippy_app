import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateArticleCommentParams extends Equatable {
  final int articleId;
  final String authorId;
  final String content;
  final int? parentId;

  const CreateArticleCommentParams({
    required this.articleId,
    required this.authorId,
    required this.content,
    this.parentId,
  });

  @override
  List<Object> get props {
    return [articleId, authorId, content];
  }

  Map<String, dynamic> toJson() => {
        'article_id': articleId,
        'author_id': authorId,
        'content': content,
        'parent_id': parentId,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
