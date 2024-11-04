import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';

@immutable
class UserInteraction extends Equatable {
  final int? id;
  final String userId;
  final int articleId;
  final InteractionType type;
  final int? readPercent;
  final int? readDuration;

  const UserInteraction({
    this.id,
    required this.userId,
    required this.articleId,
    required this.type,
    this.readPercent,
    this.readDuration,
  });

  @override
  List<Object> get props {
    return [
      userId,
      articleId,
      type,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'user_id': userId,
        'article_id': articleId,
        'interaction_type': type,
        'read_percent': readPercent,
        'read_duration': readDuration,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
