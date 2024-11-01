import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';

@immutable
class UserSubscription extends Equatable {
  final int id;
  final String userId;
  final int contentTypeId;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.contentTypeId,
  });

  @override
  List<Object?> get props {
    return [id, userId, contentTypeId];
  }

  dynamic toJson() => {
        'id': id,
        'user_id': userId,
        'content_type_id': contentTypeId,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserSubscriptionEntity toCreateEntity() {
    return UserSubscriptionEntity(
      id: id,
      userId: userId,
      contentTypeId: contentTypeId,
    );
  }
}
