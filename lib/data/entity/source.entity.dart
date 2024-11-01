// ignore_for_file: non_constant_identifier_names

import 'package:zippy/domain/enum/content_type.enum.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SourceEntity extends Equatable {
  final int? id;
  final int platform_id;
  final int contentTypeId;
  final String category;
  final bool status;

  SourceEntity({
    this.id,
    required this.platform_id,
    required this.contentTypeId,
    required this.category,
    required this.status,
  });

  @override
  List<Object> get props {
    return [platform_id, contentTypeId, category, status];
  }

  factory SourceEntity.fromJson(Map<String, dynamic> json) {
    return SourceEntity(
      id: json['id'],
      platform_id: json['platform_id'],
      contentTypeId: json['content_type_id'],
      category: json['category'],
      status: json['status'],
    );
  }

  Source toModel() {
    return Source(
      id: id,
      platformId: platform_id,
      contentTypeId: contentTypeId,
      category: category,
      status: status,
    );
  }
}
