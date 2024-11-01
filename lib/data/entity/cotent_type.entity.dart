import 'package:zippy/domain/model/content_type.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ContentTypeEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image_url;

  const ContentTypeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image_url,
  });

  @override
  List<Object> get props {
    return [id, name, description, image_url];
  }

  factory ContentTypeEntity.fromJson(Map<String, dynamic> json) {
    return ContentTypeEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image_url: json['image_url'],
    );
  }

  ContentType toModel() {
    return ContentType(
      id: id,
      name: name,
      description: description,
      imageUrl: image_url,
    );
  }
}
