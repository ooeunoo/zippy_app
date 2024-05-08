import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Content extends Equatable {
  final int? id;
  final int categoryId;
  final String url;
  final String title;
  final String author;
  final String? contentText;
  final String? contentImgUrl;

  //
  final bool isAd;

  const Content({
    this.id,
    required this.categoryId,
    required this.url,
    required this.title,
    required this.author,
    this.contentText,
    this.contentImgUrl,
    this.isAd = false,
  });

  @override
  List<Object> get props {
    return [
      categoryId,
      url,
      title,
      author,
      isAd,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'categoryId': categoryId,
        'url': url,
        'title': title,
        "author": author,
        "contentText": contentText,
        "contentImgUrl": contentImgUrl,
        'isAd': isAd
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
