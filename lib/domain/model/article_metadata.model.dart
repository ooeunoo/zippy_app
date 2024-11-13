import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ArticleMetadata extends Equatable {
  final int id;
  final int articleId;
  final int viewCount;
  final int likeCount;
  final int shareCount;
  final int commentCount;
  final int bookmarkCount;
  final int reportCount;
  final DateTime updatedAt;

  const ArticleMetadata({
    required this.id,
    required this.articleId,
    required this.viewCount,
    required this.likeCount,
    required this.shareCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.reportCount,
    required this.updatedAt,
  });

  @override
  List<Object> get props {
    return [
      id,
      articleId,
      viewCount,
      likeCount,
      shareCount,
      commentCount,
      bookmarkCount,
      reportCount,
      updatedAt,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'article_id': articleId,
        'view_count': viewCount,
        'like_count': likeCount,
        'share_count': shareCount,
        'comment_count': commentCount,
        'bookmark_count': bookmarkCount,
        'report_count': reportCount,
        'updated_at': updatedAt,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
