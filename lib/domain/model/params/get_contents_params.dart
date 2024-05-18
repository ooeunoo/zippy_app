import 'package:zippy/app/utils/assets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/user_category.dart';

@immutable
class GetContentsParams extends Equatable {
  final List<UserCategory> categories;
  final int limit;

  const GetContentsParams({
    required this.categories,
    this.limit = 1000,
  });

  @override
  List<Object> get props {
    return [categories];
  }

  Map<String, dynamic> toJson() => {'limit': limit, 'categories': categories};

  @override
  String toString() {
    return toJson().toString();
  }

  getCategoryIds() {
    return categories.map((category) => category.id).toList();
  }
}
