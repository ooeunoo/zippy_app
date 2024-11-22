import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';

@immutable
class UserBookmarkFolder extends Equatable {
  final int id;
  final String user_id;
  final String name;
  final String? description;

  const UserBookmarkFolder({
    required this.id,
    required this.user_id,
    required this.name,
    this.description,
  });

  @override
  List<Object> get props {
    return [
      id,
      user_id,
      name,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'user_id': user_id,
        'name': name,
        'description': description,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserBookmarkFolderEntity toCreateEntity() {
    return UserBookmarkFolderEntity(
      id: id,
      user_id: user_id,
      name: name,
      description: description,
    );
  }
}
