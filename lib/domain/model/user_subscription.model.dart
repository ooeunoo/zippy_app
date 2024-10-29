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
