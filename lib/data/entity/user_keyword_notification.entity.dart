import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_keyword_notification.model.dart';

@immutable
class UserKeywordNotificationEntity extends Equatable {
  final int id;
  final String user_id;
  final String keyword;
  final bool is_active;

  const UserKeywordNotificationEntity({
    required this.id,
    required this.user_id,
    required this.keyword,
    required this.is_active,
  });

  @override
  List<Object> get props {
    return [id, user_id, keyword, is_active];
  }

  factory UserKeywordNotificationEntity.fromJson(Map<String, dynamic> json) {
    return UserKeywordNotificationEntity(
      id: json['id'],
      user_id: json['user_id'],
      keyword: json['keyword'],
      is_active: json['is_active'],
    );
  }

  UserKeywordNotification toModel() {
    return UserKeywordNotification(
      id: id,
      userId: user_id,
      keyword: keyword,
      isActive: is_active,
    );
  }
}
