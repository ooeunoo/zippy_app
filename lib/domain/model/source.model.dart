import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Source extends Equatable {
  final int? id;
  final int platformId;
  final int contentTypeId;
  final String category;
  final bool status;

  const Source({
    this.id,
    required this.platformId,
    required this.contentTypeId,
    required this.category,
    required this.status,
  });

  @override
  List<Object> get props {
    return [platformId, contentTypeId, category, status];
  }

  dynamic toJson() => {
        'id': id,
        'platformId': platformId,
        'contentTypeId': contentTypeId,
        'category': category,
        'status': status,
      };

  Map<int, Source> toIdAssign(Map<int, Source> map) {
    if (id != null) {
      map[id!] = Source(
        platformId: platformId,
        contentTypeId: contentTypeId,
        category: category,
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
