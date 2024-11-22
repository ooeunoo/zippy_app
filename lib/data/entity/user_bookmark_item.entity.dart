import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/domain/model/user_bookmark_item.model.dart';

@immutable
class UserBookmarkItemEntity extends Equatable {
  final int id;
  final String user_id;
  final int folder_id;
  final int article_id;

  final ArticleEntity? article;

  const UserBookmarkItemEntity({
    required this.id,
    required this.user_id,
    required this.folder_id,
    required this.article_id,
    this.article,
  });

  @override
  List<Object> get props {
    return [id, user_id, folder_id, article_id];
  }

  factory UserBookmarkItemEntity.fromJson(Map<String, dynamic> json) {
    return UserBookmarkItemEntity(
      id: json['id'],
      user_id: json['user_id'],
      folder_id: json['folder_id'],
      article_id: json['article_id'],
      article: json['articles'] != null
          ? ArticleEntity.fromJson(json['articles'])
          : null,
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'folder_id': folder_id,
        'article_id': article_id,
      };

  UserBookmarkItem toModel() {
    return UserBookmarkItem(
      id: id,
      userId: user_id,
      folderId: folder_id,
      articleId: article_id,
      article: article?.toModel(),
    );
  }
}
