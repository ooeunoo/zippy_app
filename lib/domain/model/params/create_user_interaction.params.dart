import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';

@immutable
class CreateUserInteractionParams extends Equatable {
  final String userId;
  final int articleId;
  final InteractionType interactionType;
  final int? readPercent;
  final int? readDuration;

  const CreateUserInteractionParams({
    required this.interactionType,
    required this.userId,
    required this.articleId,
    this.readPercent = 0,
    this.readDuration = 0,
  });
  @override
  List<Object> get props {
    return [interactionType, userId, articleId];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'article_id': articleId,
        'interaction_type': interactionType.name,
        'read_percent': readPercent,
        'read_duration': readDuration,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
