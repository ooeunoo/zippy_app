import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class KeywordRankSnapshot extends Equatable {
  final String keyword;
  final int? contentTypeId;
  final String? contentTypeName;
  final int currentRank;
  final int previousRank;
  final int rankChange;
  final double score;
  final int articleCount;
  final int interactionCount;
  final double interactionScore;
  final List<String>? descriptions;
  final DateTime? snapshotTime;

  const KeywordRankSnapshot({
    required this.keyword,
    this.contentTypeId,
    this.contentTypeName,
    required this.currentRank,
    required this.previousRank,
    required this.rankChange,
    required this.score,
    required this.articleCount,
    required this.interactionCount,
    required this.interactionScore,
    this.descriptions,
    this.snapshotTime,
  });

  @override
  List<Object> get props {
    return [
      keyword,
      currentRank,
      previousRank,
      rankChange,
      score,
      articleCount,
      interactionCount,
      interactionScore,
    ];
  }

  dynamic toJson() => {
        'keyword': keyword,
        'content_type_id': contentTypeId,
        'content_type_name': contentTypeName,
        'current_rank': currentRank,
        'previous_rank': previousRank,
        'rank_change': rankChange,
        'score': score,
        'article_count': articleCount,
        'interaction_count': interactionCount,
        'interaction_score': interactionScore,
        'descriptions': descriptions,
        'snapshot_time': snapshotTime,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
