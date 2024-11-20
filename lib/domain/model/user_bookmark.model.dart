import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';

@immutable
class UserBookmark extends Equatable {
  final int id;
  final String link;
  final String title;
  final String? images;
  final String folderId;

  const UserBookmark({
    required this.id,
    required this.link,
    required this.title,
    this.images,
    required this.folderId,
  });

  @override
  List<Object> get props {
    return [
      id,
      link,
      title,
      folderId,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'link': link,
        'title': title,
        "images": images,
        "folder_id": folderId,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserBookmarkEntity toCreateEntity() {
    return UserBookmarkEntity(
      id: id,
      link: link,
      title: title,
      images: images,
      folderId: folderId,
    );
  }
}
