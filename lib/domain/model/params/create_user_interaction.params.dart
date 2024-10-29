import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';

@immutable
class CreateUserInteractionParams extends Equatable {
  final InteractionType interactionType;
  final String userId;
  final int articleId;
  final double? readPersent;
  final double? readDuration;

  const CreateUserInteractionParams({
    required this.interactionType,
    required this.userId,
    required this.articleId,
    this.readPersent = 0,
    this.readDuration = 0,
  });

  @override
  List<Object> get props {
    return [interactionType, userId, articleId];
  }

  Map<String, dynamic> toJson() => {
        'interaction_type': interactionType,
        'user_id': userId,
        'article_id': articleId,
        'read_persent': readPersent,
        'read_duration': readDuration,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
