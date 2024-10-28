import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';

@immutable
class UserSubscription extends Equatable {
  final int id;
  final int platformId;

  const UserSubscription({
    required this.id,
    required this.platformId,
  });

  @override
  List<Object> get props {
    return [id, platformId];
  }

  dynamic toJson() => {
        'id': id,
        'platformId': platformId,
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

  UserSubscriptionEntity toCreateEntity() {
    return UserSubscriptionEntity(
      id: id,
      platformId: platformId,
    );
  }
}
