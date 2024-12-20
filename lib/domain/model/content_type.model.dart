import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ContentType extends Equatable {
  final int id;
  final String name;
  final String? nameEn;
  final String description;
  final String? descriptionEn;
  final String imageUrl;
  final String color;
  final bool showRank;

  const ContentType({
    required this.id,
    required this.name,
    this.nameEn,
    required this.description,
    this.descriptionEn,
    required this.imageUrl,
    required this.color,
    this.showRank = false,
  });

  @override
  List<Object> get props {
    return [id, name, description, imageUrl];
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'nameEn': nameEn,
        'description': description,
        'descriptionEn': descriptionEn,
        'imageUrl': imageUrl,
        'color': color,
        'showRank': showRank,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
