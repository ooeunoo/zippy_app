import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateUserKeywordNotificationParams extends Equatable {
  final String userId;
  final String keyword;
  final bool isActive;

  const CreateUserKeywordNotificationParams({
    required this.userId,
    required this.keyword,
    required this.isActive,
  });

  @override
  List<Object> get props {
    return [userId, keyword, isActive];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'keyword': keyword,
        'is_active': isActive,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
