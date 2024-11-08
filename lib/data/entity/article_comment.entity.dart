import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user.entity.dart';
import 'package:zippy/domain/model/article_comment.model.dart';

@immutable
class ArticleCommentEntity extends Equatable {
  final int? id;
  final int articleId;
  final int? parentId;
  final String authorId;
  final String content;
  final bool isDeleted;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  final UserEntity? author;

  const ArticleCommentEntity({
    required this.id,
    required this.articleId,
    this.parentId,
    required this.authorId,
    required this.content,
    required this.isDeleted,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    this.author,
  });

  @override
  List<Object?> get props => [
        id,
        articleId,
        parentId,
        authorId,
        content,
        isDeleted,
        likesCount,
        createdAt,
        updatedAt
      ];

  factory ArticleCommentEntity.fromJson(Map<String, dynamic> json) {
    return ArticleCommentEntity(
      id: json['id'],
      articleId: json['article_id'],
      parentId: json['parent_id'],
      authorId: json['author_id'],
      content: json['content'],
      isDeleted: json['is_deleted'],
      likesCount: json['likes_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      author:
          json['author'] != null ? UserEntity.fromJson(json['author']) : null,
    );
  }

  ArticleComment toModel() {
    return ArticleComment(
      id: id,
      articleId: articleId,
      parentId: parentId,
      authorId: authorId,
      content: content,
      isDeleted: isDeleted,
      likesCount: likesCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      author: author?.toModel(),
    );
  }
}
