import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetSearchArticlesParams extends Equatable {
  final String query;
  final int page;
  final int size;

  const GetSearchArticlesParams({
    required this.query,
    this.page = 1,
    this.size = 20,
  });

  @override
  List<Object> get props {
    return [
      query,
      page,
      size,
    ];
  }

  Map<String, dynamic> toJson() => {
        'p_query': query,
        'p_page': page,
        'p_size': size,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
