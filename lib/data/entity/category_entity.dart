// ignore_for_file: non_constant_identifier_names

import 'package:zippy/domain/model/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryEntity extends Equatable {
  final int? id;
  final int channel_id;
  final String name;
  final String? description;
  final String path;
  final bool status;

  const CategoryEntity({
    this.id,
    required this.channel_id,
    required this.name,
    this.description,
    required this.path,
    required this.status,
  });

  @override
  List<Object> get props {
    return [channel_id, name, path, status];
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'],
      channel_id: json['channel_id'],
      name: json['name'],
      description: json['description'],
      path: json['path'],
      status: json['status'],
    );
  }

  Category toModel() {
    return Category(
      id: id,
      channelId: channel_id,
      name: name,
      description: description,
      path: path,
      status: status,
    );
  }
}
