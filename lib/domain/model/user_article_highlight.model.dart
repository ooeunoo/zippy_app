import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/bookmark.entity.dart';
import 'package:zippy/data/entity/user_article_highlight.entity.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class UserArticleHighlight extends Equatable {
  final int? id;
  final String userId;
  final int articleId;
  final String content;
  final int startOffset;
  final int endOffset;
  final String color;
  final String? note;

  const UserArticleHighlight({
    this.id,
    required this.userId,
    required this.articleId,
    required this.content,
    required this.startOffset,
    required this.endOffset,
    this.color = '#000000',
    this.note,
  });

  @override
  List<Object> get props {
    return [userId, articleId, content, startOffset, endOffset, color];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'articleId': articleId,
        'content': content,
        'startOffset': startOffset,
        'endOffset': endOffset,
        'color': color,
        'note': note,
      };

  UserArticleHighlightEntity toCreateEntity() => UserArticleHighlightEntity(
        user_id: userId,
        article_id: articleId,
        content: content,
        start_offset: startOffset,
        end_offset: endOffset,
        color: color,
        note: note,
      );

  @override
  String toString() {
    return toJson().toString();
  }
}
