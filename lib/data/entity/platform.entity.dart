// ignore_for_file: non_constant_identifier_names

import 'package:zippy/data/entity/source.entity.dart';
import 'package:zippy/domain/enum/platform_type.enum.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PlatformEntity extends Equatable {
  final int? id;
  final PlatformType type;
  final String name;
  final bool status;
  final String? image_url;
  final List<SourceEntity>? sources;

  const PlatformEntity(
      {this.id,
      required this.type,
      required this.name,
      required this.status,
      this.image_url,
      this.sources});

  @override
  List<Object> get props {
    return [type, name, status];
  }

  factory PlatformEntity.fromJson(Map<String, dynamic> json) {
    return PlatformEntity(
      id: json['id'],
      type: PlatformType.values.byName(json['type']),
      name: json['name'],
      status: json['status'],
      image_url: json['image_url'],
      sources: json['sources'] != null
          ? List<SourceEntity>.from(json['sources']
              .map((sourceJson) => SourceEntity.fromJson(sourceJson)))
          : null,
    );
  }

  Platform toModel() {
    return Platform(
      id: id,
      type: type,
      name: name,
      status: status,
      sources: sources != null
          ? List<Source>.from(sources!.map((source) => source.toModel()))
          : null,
    );
  }
}
