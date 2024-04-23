// ignore_for_file: non_constant_identifier_names

import 'package:zippy/data/entity/item_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class BookmarkEntity extends Equatable {
  final int? id;
  final String user_id;
  final int item_id;
  final ItemEntity? item;

  const BookmarkEntity({
    this.id,
    required this.user_id,
    required this.item_id,
    this.item,
  });

  @override
  List<Object> get props {
    return [user_id, item_id];
  }

  factory BookmarkEntity.fromJson(Map<String, dynamic> json) {
    return BookmarkEntity(
      id: json['id'],
      user_id: json['user_id'],
      item_id: json['item_id'],
      item: json['item'] != null
          ? ItemEntity.fromJson(json['item'])
          : null, // item 속성 처리
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'item_id': item_id,
      };

  Bookmark toModel() {
    return Bookmark(
      id: id,
      userId: user_id,
      itemId: item_id,
      item: item?.toModel(),
    );
  }
}
