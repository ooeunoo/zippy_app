import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_category_entity.dart';

@immutable
class UserCategory extends Equatable {
  final int id;
  final int channelId;
  final String name;

  const UserCategory({
    required this.id,
    required this.channelId,
    required this.name,
  });

  @override
  List<Object> get props {
    return [id, channelId, name];
  }

  dynamic toJson() => {
        'id': id,
        'channelId': channelId,
        'name': name,
      };

  // Map<int, UserCategory> toIdAssign(Map<int, Category> map) {
  //   if (id != null) {
  //     map[id!] = Category(
  //       name: name,
  //       channelId: channelId,
  //       path: path,
  //       status: status,
  //       latestItemIndex: latestItemIndex,
  //     );
  //   }
  //   return map;
  // }

  @override
  String toString() {
    return toJson().toString();
  }

  UserCategoryEntity toCreateEntity() {
    return UserCategoryEntity(
      id: id,
      channelId: channelId,
      name: name,
    );
  }
}
