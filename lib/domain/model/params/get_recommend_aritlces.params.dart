import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetRecommendedArticlesParams extends Equatable {
  final String? userId;
  final String timeRange;
  final bool excludeViewed;
  final String? minPublishedAt;
  final String? maxPublishedAt;
  final int limit;

  const GetRecommendedArticlesParams({
    this.userId,
    this.timeRange = '7 days',
    this.excludeViewed = true,
    this.minPublishedAt,
    this.maxPublishedAt,
    this.limit = 100,
  });

  @override
  List<Object> get props {
    return [
      timeRange,
      excludeViewed,
      limit,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_user_id': userId,
        'p_time_range': timeRange,
        'p_exclude_viewed': excludeViewed,
        'p_min_published_at': minPublishedAt,
        'p_max_published_at': maxPublishedAt,
        'p_limit': limit,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
