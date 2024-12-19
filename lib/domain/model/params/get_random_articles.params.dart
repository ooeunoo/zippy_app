import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetRandomArticlesParams extends Equatable {
  final String? userId;
  final int limit;
  final int minHours;
  final int maxHours;
  final double similarityThreshold;
  final int candidatesPerType;

  const GetRandomArticlesParams({
    this.userId,
    this.limit = 10,
    this.minHours = 1,
    this.maxHours = 168, // 7 days
    this.similarityThreshold = 0.7,
    this.candidatesPerType = 30,
  });

  @override
  List<Object> get props {
    return [
      limit,
      minHours,
      maxHours,
      similarityThreshold,
      candidatesPerType,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_user_id': userId,
        'p_limit': limit,
        'p_min_hours': minHours,
        'p_max_hours': maxHours,
        'p_similarity_threshold': similarityThreshold,
        'p_candidates_per_type': candidatesPerType,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
