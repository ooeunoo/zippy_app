import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetArticlesByKeywordParams extends Equatable {
  final String keyword;
  final int limit;

  const GetArticlesByKeywordParams({
    required this.keyword,
    this.limit = 1000,
  });

  @override
  List<Object> get props {
    return [keyword, limit];
  }

  Map<String, dynamic> toJson() => {'keyword': keyword, 'limit': limit};

  @override
  String toString() {
    return toJson().toString();
  }
}
