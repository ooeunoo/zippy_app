import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';

@immutable
class UserSubscription extends Equatable {
  final int id;
  final String userId;
  final int contentTypeId;
  final bool isActive;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.contentTypeId,
    required this.isActive,
  });

  @override
  List<Object?> get props {
    return [id, userId, contentTypeId, isActive];
  }

  dynamic toJson() => {
        'id': id,
        'user_id': userId,
        'content_type_id': contentTypeId,
        'is_active': isActive,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserSubscriptionEntity toCreateEntity() {
    return UserSubscriptionEntity(
      id: id,
      user_id: userId,
      content_type_id: contentTypeId,
      is_active: isActive,
    );
  }
}
