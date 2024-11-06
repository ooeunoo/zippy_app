import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/content_type.model.dart';

@immutable
class Source extends Equatable {
  final int? id;
  final int platformId;
  final int? contentTypeId;
  final String category;
  final bool status;

  final ContentType? contentType;

  const Source({
    this.id,
    required this.platformId,
    this.contentTypeId,
    required this.category,
    required this.status,
    this.contentType,
  });

  @override
  List<Object> get props {
    return [platformId, category, status];
  }

  dynamic toJson() => {
        'id': id,
        'platformId': platformId,
        'contentTypeId': contentTypeId,
        'category': category,
        'status': status,
        'contentType': contentType?.toJson(),
      };

  Map<int, Source> toIdAssign(Map<int, Source> map) {
    if (id != null) {
      map[id!] = Source(
        platformId: platformId,
        contentTypeId: contentTypeId,
        category: category,
        status: status,
        contentType: contentType,
      );
    }
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
