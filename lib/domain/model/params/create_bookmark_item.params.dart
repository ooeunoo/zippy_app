import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateBookmarkItemParams extends Equatable {
  final String userId;
  final int folderId;
  final int articleId;

  const CreateBookmarkItemParams({
    required this.userId,
    required this.folderId,
    required this.articleId,
  });

  @override
  List<Object> get props {
    return [userId, folderId, articleId];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'folder_id': folderId,
        'article_id': articleId,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
