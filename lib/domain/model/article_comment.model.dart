import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user.model.dart';

@immutable
class ArticleComment extends Equatable {
  final int? id;
  final int articleId;
  final int? parentId;
  final String authorId;
  final String content;
  final bool isDeleted;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  final User? author;

  const ArticleComment({
    this.id,
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
  List<Object> get props {
    return [
      articleId,
      authorId,
      content,
      isDeleted,
      likesCount,
      createdAt,
      updatedAt,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'articleId': articleId,
        'parentId': parentId,
        'authorId': authorId,
        "content": content,
        "isDeleted": isDeleted,
        "likesCount": likesCount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "author": author?.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
