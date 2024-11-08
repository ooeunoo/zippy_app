import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/cotent_type.entity.dart';

@immutable
class ContentType extends Equatable {
  final int id;
  final String name;
  final String? nameEn;
  final String description;
  final String? descriptionEn;
  final String imageUrl;
  final String color;

  const ContentType({
    required this.id,
    required this.name,
    this.nameEn,
    required this.description,
    this.descriptionEn,
    required this.imageUrl,
    required this.color,
  });

  @override
  List<Object> get props {
    return [id, name, description, imageUrl];
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'name_en': nameEn,
        'description': description,
        'description_en': descriptionEn,
        'image_url': imageUrl,
        'color': color,
      };

  ContentTypeEntity toCreateEntity() => ContentTypeEntity(
        id: id,
        name: name,
        name_en: nameEn,
        description: description,
        description_en: descriptionEn,
        image_url: imageUrl,
        color: color,
      );

  @override
  String toString() {
    return toJson().toString();
  }
}
