import 'package:zippy/domain/model/content_type.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ContentTypeEntity extends Equatable {
  final int id;
  final String name;
  final String? name_en;
  final String description;
  final String? description_en;
  final String image_url;
  final String color;

  const ContentTypeEntity({
    required this.id,
    required this.name,
    this.name_en,
    required this.description,
    this.description_en,
    required this.image_url,
    required this.color,
  });

  @override
  List<Object> get props {
    return [id, name, description, image_url];
  }

  factory ContentTypeEntity.fromJson(Map<String, dynamic> json) {
    return ContentTypeEntity(
      id: json['id'],
      name: json['name'],
      name_en: json['name_en'],
      description: json['description'],
      description_en: json['description_en'],
      image_url: json['image_url'],
      color: json['color'],
    );
  }

  ContentType toModel() {
    return ContentType(
      id: id,
      name: name,
      nameEn: name_en,
      description: description,
      descriptionEn: description_en,
      imageUrl: image_url,
      color: color,
    );
  }
}
