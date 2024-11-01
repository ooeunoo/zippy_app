import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateUserSubscriptionParams extends Equatable {
  final String userId;
  final int contentTypeId;

  const CreateUserSubscriptionParams({
    required this.userId,
    required this.contentTypeId,
  });

  @override
  List<Object> get props => [userId, contentTypeId];

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'content_type_id': contentTypeId,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
