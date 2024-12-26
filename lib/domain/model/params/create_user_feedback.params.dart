import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateUserFeedbackParams extends Equatable {
  final String? userId;
  final String feedback;

  const CreateUserFeedbackParams({
    this.userId,
    required this.feedback,
  });

  @override
  List<Object> get props => [feedback];

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'feedback': feedback,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
