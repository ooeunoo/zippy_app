import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/article_metadata.model.dart';

@immutable
class ArticleMetadataEntity extends Equatable {
  final int id;
  final int article_id;
  final int view_count;
  final int like_count;
  final int share_count;
  final int comment_count;
  final int bookmark_count;
  final int report_count;
  final DateTime updated_at;

  const ArticleMetadataEntity({
    required this.id,
    required this.article_id,
    required this.view_count,
    required this.like_count,
    required this.share_count,
    required this.comment_count,
    required this.bookmark_count,
    required this.report_count,
    required this.updated_at,
  });

  @override
  List<Object?> get props => [
        id,
        article_id,
        view_count,
        like_count,
        share_count,
        comment_count,
        bookmark_count,
        report_count,
        updated_at,
      ];

  factory ArticleMetadataEntity.fromJson(Map<String, dynamic> json) {
    return ArticleMetadataEntity(
      id: json['id'],
      article_id: json['article_id'],
      view_count: json['view_count'],
      like_count: json['like_count'],
      share_count: json['share_count'],
      comment_count: json['comment_count'],
      bookmark_count: json['bookmark_count'],
      report_count: json['report_count'],
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  ArticleMetadata toModel() {
    return ArticleMetadata(
      id: id,
      articleId: article_id,
      viewCount: view_count,
      likeCount: like_count,
      shareCount: share_count,
      commentCount: comment_count,
      bookmarkCount: bookmark_count,
      reportCount: report_count,
      updatedAt: updated_at,
    );
  }
}
