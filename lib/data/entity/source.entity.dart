import 'package:zippy/data/entity/cotent_type.entity.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SourceEntity extends Equatable {
  final int? id;
  final int platform_id;
  final int? contentTypeId;
  final String category;
  final bool status;

  final ContentTypeEntity? contentType;

  const SourceEntity({
    this.id,
    required this.platform_id,
    this.contentTypeId,
    required this.category,
    required this.status,
    this.contentType,
  });

  @override
  List<Object> get props {
    return [platform_id, category, status];
  }

  factory SourceEntity.fromJson(Map<String, dynamic> json) {
    return SourceEntity(
      id: json['id'],
      platform_id: json['platform_id'],
      contentTypeId: json['content_type_id'],
      category: json['category'],
      status: json['status'],
      contentType: json['content_types'] != null
          ? ContentTypeEntity.fromJson(json['content_types'])
          : null,
    );
  }

  Source toModel() {
    return Source(
      id: id,
      platformId: platform_id,
      contentTypeId: contentTypeId,
      category: category,
      status: status,
      contentType: contentType?.toModel(),
    );
  }
}
