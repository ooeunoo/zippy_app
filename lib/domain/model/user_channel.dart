import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:zippy/domain/model/category.dart';

@immutable
class UserChannel extends Equatable {
  final int? id;
  final String userId;
  final int categoryId;
  final Category? category;

  const UserChannel(
      {this.id, required this.userId, required this.categoryId, this.category});

  @override
  List<Object> get props {
    return [userId, categoryId];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'categoryId': categoryId,
        'category': category,
      };

  UserChannelEntity toCreateEntity() =>
      UserChannelEntity(user_id: userId, category_id: categoryId);

  @override
  String toString() {
    return toJson().toString();
  }
}
