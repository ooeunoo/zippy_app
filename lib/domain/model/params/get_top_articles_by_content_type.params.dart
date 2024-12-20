import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetTopArticlesByContentTypeParams extends Equatable {
  final String? userId;
  final int? timeRange;
  final int? candidatesPerType;

  const GetTopArticlesByContentTypeParams({
    this.userId,
    this.timeRange = 24,
    this.candidatesPerType = 30,
  });

  @override
  List<Object> get props {
    return [];
  }

  Map<String, dynamic> toJson() => {
        'p_user_id': userId,
        'p_time_range': timeRange,
        'p_candidates_per_type': candidatesPerType,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
