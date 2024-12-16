import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetSearchArticlesParams extends Equatable {
  final String query;
  final String timeRange;
  final int limit;
  final String? search;
  final double? similarityThreshold;

  const GetSearchArticlesParams({
    required this.query,
    this.timeRange = '30 days',
    this.limit = 100,
    this.search,
    this.similarityThreshold = 0.9,
  });

  @override
  List<Object> get props {
    return [
      query,
      timeRange,
      limit,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_query': query,
        'p_time_range': timeRange,
        'p_limit': limit,
        'p_search': search,
        'p_similarity_threshold': similarityThreshold,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
