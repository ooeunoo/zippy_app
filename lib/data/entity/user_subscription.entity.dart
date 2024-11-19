import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

@immutable
class UserSubscriptionEntity extends Equatable {
  final int id;
  final String user_id;
  final int content_type_id;
  final bool is_active;

  const UserSubscriptionEntity({
    required this.id,
    required this.user_id,
    required this.content_type_id,
    required this.is_active,
  });

  @override
  List<Object> get props {
    return [id, user_id, content_type_id, is_active];
  }

  factory UserSubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionEntity(
      id: json['id'],
      user_id: json['user_id'],
      content_type_id: json['content_type_id'],
      is_active: json['is_active'],
    );
  }

  UserSubscription toModel() {
    return UserSubscription(
      id: id,
      userId: user_id,
      contentTypeId: content_type_id,
      isActive: is_active,
    );
  }
}
