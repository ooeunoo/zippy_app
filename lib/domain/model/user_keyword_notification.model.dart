import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_keyword_notification.entity.dart';

@immutable
class UserKeywordNotification extends Equatable {
  final int id;
  final String userId;
  final String keyword;
  final bool isActive;

  const UserKeywordNotification({
    required this.id,
    required this.userId,
    required this.keyword,
    required this.isActive,
  });

  @override
  List<Object?> get props {
    return [id, userId, keyword, isActive];
  }

  dynamic toJson() => {
        'id': id,
        'user_id': userId,
        'keyword': keyword,
        'is_active': isActive,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  UserKeywordNotificationEntity toCreateEntity() {
    return UserKeywordNotificationEntity(
      id: id,
      user_id: userId,
      keyword: keyword,
      is_active: isActive,
    );
  }
}
