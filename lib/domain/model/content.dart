import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/item.dart';

@immutable
class Content extends Item {
  final int? id;
  final int categoryId;
  final String url;
  final String title;
  final int itemIndex;
  final String author;
  final String? contentText;
  final String? contentImgUrl;

  const Content({
    this.id,
    required this.categoryId,
    required this.url,
    required this.title,
    required this.itemIndex,
    required this.author,
    this.contentText,
    this.contentImgUrl,
  }) : super(isAd: false);

  @override
  List<Object> get props {
    return [
      ...super.props,
      categoryId,
      url,
      title,
      itemIndex,
      author,
    ];
  }

  @override
  dynamic toJson() => {
        'id': id,
        'categoryId': categoryId,
        'url': url,
        'title': title,
        'itemIndex': itemIndex,
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
