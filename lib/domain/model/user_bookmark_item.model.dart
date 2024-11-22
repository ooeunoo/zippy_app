import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark_item.entity.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class UserBookmarkItem extends Equatable {
  final int id;
  final String userId;
  final int folderId;
  final int articleId;
  final Article? article;

  const UserBookmarkItem({
    required this.id,
    required this.userId,
    required this.folderId,
    required this.articleId,
    this.article,
  });

  @override
  List<Object> get props {
    return [
      id,
      userId,
      folderId,
      articleId,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'folderId': folderId,
        'articleId': articleId,
        'article': article,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserBookmarkItemEntity toCreateEntity() {
    return UserBookmarkItemEntity(
      id: id,
      user_id: userId,
      folder_id: folderId,
      article_id: articleId,
    );
  }
}
