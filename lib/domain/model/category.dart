import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Category extends Equatable {
  final int? id;
  final int communityId;
  final String name;
  final String path;
  final bool status;
  final int latestItemIndex;

  const Category({
    this.id,
    required this.communityId,
    required this.name,
    required this.path,
    required this.status,
    required this.latestItemIndex,
  });

  @override
  List<Object> get props {
    return [communityId, name, path, status, latestItemIndex];
  }

  dynamic toJson() => {
        'id': id,
        'communityId': communityId,
        'name': name,
        'path': path,
        'status': status,
        "latestItemIndex": latestItemIndex,
      };

  Map<int, Category> toIdAssign(Map<int, Category> map) {
    if (id != null) {
      map[id!] = Category(
        name: name,
        communityId: communityId,
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
