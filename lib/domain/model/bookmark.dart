import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/domain/model/content.dart';

@immutable
class Bookmark extends Equatable {
  final int? id;
  final String userId;
  final int itemId;
  final Content? item;

  const Bookmark({
    this.id,
    required this.userId,
    required this.itemId,
    this.item,
  });

  @override
  List<Object> get props {
    return [userId, itemId];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'itemId': itemId,
        'item': item,
      };

  BookmarkEntity toCreateEntity() =>
      BookmarkEntity(user_id: userId, item_id: itemId);

  @override
  String toString() {
    return toJson().toString();
  }
}
