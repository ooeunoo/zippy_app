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
  final int latestItemIndex;

  const Category({
    this.id,
    required this.channelId,
    required this.name,
    this.description,
    required this.path,
    required this.status,
    required this.latestItemIndex,
  });

  @override
  List<Object> get props {
    return [channelId, name, path, status, latestItemIndex];
  }

  dynamic toJson() => {
        'id': id,
        'channelId': channelId,
        'name': name,
        'description': description,
        'path': path,
        'status': status,
        "latestItemIndex": latestItemIndex,
      };

  Map<int, Category> toIdAssign(Map<int, Category> map) {
    if (id != null) {
      map[id!] = Category(
        name: name,
        description: description,
        channelId: channelId,
        path: path,
        status: status,
        latestItemIndex: latestItemIndex,
      );
    }
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
