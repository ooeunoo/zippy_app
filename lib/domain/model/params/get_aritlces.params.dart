import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GetArticlesParams extends Equatable {
  final int limit;
  final String? search;

  const GetArticlesParams({
    this.limit = 1000,
    this.search,
  });

  @override
  List<Object> get props {
    return [];
  }

  Map<String, dynamic> toJson() => {'limit': limit, 'search': search};

  @override
  String toString() {
    return toJson().toString();
  }
}
