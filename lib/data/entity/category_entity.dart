// ignore_for_file: non_constant_identifier_names

import 'package:cocomu/domain/model/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryEntity extends Equatable {
  final int? id;
  final int community_id;
  final String name;
  final String path;
  final bool status;
  final int latest_item_index;

  const CategoryEntity(
      {this.id,
      required this.community_id,
      required this.name,
      required this.path,
      required this.status,
      required this.latest_item_index});

  @override
  List<Object> get props {
    return [community_id, name, path, status, latest_item_index];
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'],
      community_id: json['community_id'],
      name: json['name'],
      path: json['path'],
      status: json['status'],
      latest_item_index: json['latest_item_index'],
    );
  }

  Category toModel() {
    return Category(
      id: id,
      communityId: community_id,
      name: name,
      path: path,
      status: status,
      latestItemIndex: latest_item_index,
    );
  }
}
