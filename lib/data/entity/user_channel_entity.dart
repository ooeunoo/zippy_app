import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_channel.dart';

@immutable
class UserChannelEntity extends Equatable {
  final int? id;
  final String user_id;
  final int category_id;
  final CategoryEntity? category;

  const UserChannelEntity(
      {this.id,
      required this.user_id,
      required this.category_id,
      this.category});

  @override
  List<Object> get props {
    return [user_id, category_id];
  }

  factory UserChannelEntity.fromJson(Map<String, dynamic> json) {
    return UserChannelEntity(
      id: json['id'],
      user_id: json['user_id'],
      category_id: json['category_id'],
      category: json['category'] != null
          ? CategoryEntity.fromJson(json['category'])
          : null, // ite
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'category_id': category_id,
      };

  UserChannel toModel() {
    return UserChannel(
      id: id,
      userId: user_id,
      categoryId: category_id,
    );
  }
}
