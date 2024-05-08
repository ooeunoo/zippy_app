import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Category extends Equatable {
  final int? id;
  final int channelId;
  final String name;
  final String? description;
  final String path;
  final bool status;

  const Category({
    this.id,
    required this.channelId,
    required this.name,
    this.description,
    required this.path,
    required this.status,
  });

  @override
  List<Object> get props {
    return [channelId, name, path, status];
  }

  dynamic toJson() => {
        'id': id,
        'channelId': channelId,
        'name': name,
        'description': description,
        'path': path,
        'status': status,
      };

  Map<int, Category> toIdAssign(Map<int, Category> map) {
    if (id != null) {
      map[id!] = Category(
        name: name,
        description: description,
        channelId: channelId,
        path: path,
        status: status,
      );
    }
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
