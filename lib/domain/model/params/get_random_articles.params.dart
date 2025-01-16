import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetRandomArticlesParams extends Equatable {
  final String timeRange;
  final int limit;

  const GetRandomArticlesParams({
    this.timeRange = '7 days',
    this.limit = 20,
  });

  @override
  List<Object> get props {
    return [
      timeRange,
      limit,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_time_range': timeRange,
        'p_limit': limit,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
