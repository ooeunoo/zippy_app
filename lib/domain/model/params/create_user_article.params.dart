import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateUserArticleHighlightParams extends Equatable {
  final String userId;
  final int articleId;
  final String content;
  final int startOffset;
  final int endOffset;
  final String? color;
  final String? note;

  const CreateUserArticleHighlightParams({
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
    return [userId, articleId, content, startOffset, endOffset];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'article_id': articleId,
        'content': content,
        'start_offset': startOffset,
        'end_offset': endOffset,
        'color': color,
        'note': note,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
