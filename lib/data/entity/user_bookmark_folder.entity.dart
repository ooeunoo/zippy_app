// ignore_for_file: non_constant_identifier_names

import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/domain/model/bookmark.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

@immutable
class UserBookmarkFolderEntity extends Equatable {
  final int id;
  final String user_id;
  final String name;
  final String? description;

  const UserBookmarkFolderEntity({
    required this.id,
    required this.user_id,
    required this.name,
    this.description,
  });

  @override
  List<Object> get props {
    return [id, user_id, name];
  }

  factory UserBookmarkFolderEntity.fromJson(Map<String, dynamic> json) {
    return UserBookmarkFolderEntity(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'name': name,
        'description': description,
      };

  UserBookmarkFolder toModel() {
    return UserBookmarkFolder(
      id: id,
      user_id: user_id,
      name: name,
      description: description,
    );
  }
}
