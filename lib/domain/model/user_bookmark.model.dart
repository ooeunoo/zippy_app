import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';

@immutable
class UserBookmark extends Equatable {
  final int id;
  final String link;
  final String title;
  final String? content;
  final String? images;

  const UserBookmark({
    required this.id,
    required this.link,
    required this.title,
    this.content,
    this.images,
  });

  @override
  List<Object> get props {
    return [
      id,
      link,
      title,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'link': link,
        'title': title,
        "content": content,
        "images": images,
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
      content: content,
      images: images,
    );
  }
}
