import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_article_highlight.model.dart';

@immutable
class UserArticleHighlightEntity extends Equatable {
  final int? id;
  final String user_id;
  final int article_id;
  final String content;
  final int start_offset;
  final int end_offset;
  final String color;
  final String? note;

  const UserArticleHighlightEntity({
    this.id,
    required this.user_id,
    required this.article_id,
    required this.content,
    required this.start_offset,
    required this.end_offset,
    this.color = '#000000',
    this.note,
  });

  @override
  List<Object> get props {
    return [user_id, article_id, content, start_offset, end_offset, color];
  }

  factory UserArticleHighlightEntity.fromJson(Map<String, dynamic> json) {
    return UserArticleHighlightEntity(
      id: json['id'],
      user_id: json['user_id'],
      article_id: json['article_id'],
      content: json['content'],
      start_offset: json['start_offset'],
      end_offset: json['end_offset'],
      color: json['color'],
      note: json['note'],
    );
  }

  UserArticleHighlight toModel() {
    return UserArticleHighlight(
      id: id,
      userId: user_id,
      articleId: article_id,
      content: content,
      startOffset: start_offset,
      endOffset: end_offset,
      color: color,
      note: note,
    );
  }
}
