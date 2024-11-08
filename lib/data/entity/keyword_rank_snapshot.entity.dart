import 'package:zippy/data/entity/cotent_type.entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';

@immutable
class KeywordRankSnapshotEntity extends Equatable {
  final String keyword;
  final int? content_type_id;
  final String? content_type_name;
  final int current_rank;
  final int previous_rank;
  final int rank_change;
  final double score;
  final int article_count;
  final int interaction_count;
  final double interaction_score;
  final List<String>? descriptions;

  const KeywordRankSnapshotEntity({
    required this.keyword,
    this.content_type_id,
    this.content_type_name,
    required this.current_rank,
    required this.previous_rank,
    required this.rank_change,
    required this.score,
    required this.article_count,
    required this.interaction_count,
    required this.interaction_score,
    this.descriptions,
  });

  @override
  List<Object> get props {
    return [
      keyword,
      current_rank,
      previous_rank,
      rank_change,
      score,
      article_count,
      interaction_count,
      interaction_score,
    ];
  }

  factory KeywordRankSnapshotEntity.fromJson(Map<String, dynamic> json) {
    return KeywordRankSnapshotEntity(
      keyword: json['keyword'],
      content_type_id: json['content_type_id'],
      content_type_name: json['content_type_name'],
      current_rank: json['current_rank'],
      previous_rank: json['previous_rank'],
      rank_change: json['rank_change'],
      score: (json['score'] as num).toDouble(),
      article_count: json['article_count'],
      interaction_count: json['interaction_count'],
      interaction_score: (json['interaction_score'] as num).toDouble(),
      descriptions: json['descriptions'] != null
          ? (json['descriptions'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
    );
  }
  KeywordRankSnapshot toModel() {
    return KeywordRankSnapshot(
      keyword: keyword,
      contentTypeId: content_type_id,
      contentTypeName: content_type_name,
      currentRank: current_rank,
      previousRank: previous_rank,
      rankChange: rank_change,
      score: score,
      articleCount: article_count,
      interactionCount: interaction_count,
      interactionScore: interaction_score,
      descriptions: descriptions,
    );
  }
}
