import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Item extends Equatable {
  final int? id;
  final int categoryId;
  final String url;
  final String title;
  final int itemIndex;
  final String author;
  final String contentText;
  final String? contentImgUrl;

  const Item({
    this.id,
    required this.categoryId,
    required this.url,
    required this.title,
    required this.itemIndex,
    required this.author,
    required this.contentText,
    this.contentImgUrl,
  });

  @override
  List<Object> get props {
    return [
      categoryId,
      url,
      title,
      itemIndex,
      author,
      contentText,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'categoryId': categoryId,
        'title': title,
        'itemIndex': itemIndex,
        "author": author,
        "contentText": contentText,
        "contentImgUrl": contentImgUrl,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
