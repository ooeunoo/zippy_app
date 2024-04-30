import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';

@immutable
class UserBookmark extends Equatable {
  final int id;
  final String url;
  final String title;
  final String? contentText;
  final String? contentImgUrl;

  const UserBookmark({
    required this.id,
    required this.url,
    required this.title,
    this.contentText,
    this.contentImgUrl,
  });

  @override
  List<Object> get props {
    return [
      id,
      url,
      title,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'url': url,
        'title': title,
        "contentText": contentText,
        "contentImgUrl": contentImgUrl,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserBookmarkEntity toCreateEntity() {
    return UserBookmarkEntity(
      id: id,
      url: url,
      title: title,
      contentText: contentText,
      contentImgUrl: contentImgUrl,
    );
  }
}
