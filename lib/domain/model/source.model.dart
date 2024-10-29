import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/source_type.enum.dart';

@immutable
class Source extends Equatable {
  final int? id;
  final int platformId;
  final String category;
  final bool status;
  final SourceType? type;

  Source({
    this.id,
    required this.platformId,
    required this.category,
    required this.status,
    this.type,
  });

  @override
  List<Object> get props {
    return [platformId, category, status];
  }

  dynamic toJson() => {
        'id': id,
        'platformId': platformId,
        'category': category,
        'status': status,
        'type': type,
      };

  Map<int, Source> toIdAssign(Map<int, Source> map) {
    if (id != null) {
      map[id!] = Source(
        platformId: platformId,
        category: category,
        status: status,
        type: type,
      );
    }
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
