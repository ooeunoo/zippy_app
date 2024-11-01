import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

@immutable
class UserSubscriptionEntity extends Equatable {
  final int id;
  final String userId;
  final int contentTypeId;

  const UserSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.contentTypeId,
  });

  @override
  List<Object> get props {
    return [id, userId, contentTypeId];
  }

  factory UserSubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionEntity(
      id: json['id'],
      userId: json['user_id'],
      contentTypeId: json['content_type_id'],
    );
  }

  UserSubscription toModel() {
    return UserSubscription(
      id: id,
      userId: userId,
      contentTypeId: contentTypeId,
    );
  }
}
