import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetRandomArticlesParams extends Equatable {
  final String? userId;
  final int limit;
  final int minHours;
  final int maxHours;
  final int candidatesPerType;

  const GetRandomArticlesParams({
    this.userId,
    this.limit = 50,
    this.minHours = 24,
    this.maxHours = 720, // 30일
    this.candidatesPerType = 30,
  });

  @override
  List<Object> get props {
    return [
      limit,
      minHours,
      maxHours,
      candidatesPerType,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_user_id': userId,
        'p_limit': limit,
        'p_min_hours': minHours,
        'p_max_hours': maxHours,
        'p_candidates_per_type': candidatesPerType,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
