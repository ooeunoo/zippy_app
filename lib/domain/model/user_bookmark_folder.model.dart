import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';

@immutable
class UserBookmarkFolder extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const UserBookmarkFolder({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      createdAt,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserBookmarkFolderEntity toCreateEntity() {
    return UserBookmarkFolderEntity(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
    );
  }
}
