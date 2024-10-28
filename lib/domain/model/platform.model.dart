import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/platform_type.enum.dart';
import 'package:zippy/domain/model/source.model.dart';

@immutable
class Platform extends Equatable {
  final int? id;
  final PlatformType type;
  final String name;
  final String? imageUrl;
  final bool status;
  final List<Source>? sources;

  const Platform(
      {this.id,
      required this.type,
      required this.name,
      this.imageUrl,
      required this.status,
      this.sources});

  @override
  List<Object> get props {
    return [type, name, status];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'imageUrl': imageUrl,
        'status': status,
        'sources': sources?.map((source) => source.toJson()).toList(),
      };

  Map<int, Platform> toIdAssign(Map<int, Platform> map) {
    if (id != null) {
      map[id!] =
          Platform(type: type, name: name, imageUrl: imageUrl, status: status);
    }
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
