import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/bookmark.entity.dart';
import 'package:zippy/data/entity/cotent_type.entity.dart';
import 'package:zippy/domain/model/article.model.dart';

@immutable
class ContentType extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  const ContentType({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object> get props {
    return [id, name, description, imageUrl];
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
      };

  ContentTypeEntity toCreateEntity() => ContentTypeEntity(
      id: id, name: name, description: description, image_url: imageUrl);

  @override
  String toString() {
    return toJson().toString();
  }
}
