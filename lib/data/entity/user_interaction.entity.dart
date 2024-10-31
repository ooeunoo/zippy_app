import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/user_article_highlight.model.dart';
import 'package:zippy/domain/model/user_interaction.model%20.dart';

@immutable
class UserInteractionEntity extends Equatable {
  final int? id;
  final String user_id;
  final int article_id;
  final InteractionType type;
  final double? read_time;
  final double? read_duration;

  const UserInteractionEntity({
    this.id,
    required this.user_id,
    required this.article_id,
    required this.type,
    this.read_time,
    this.read_duration,
  });

  @override
  List<Object> get props {
    return [user_id, article_id, type];
  }

  factory UserInteractionEntity.fromJson(Map<String, dynamic> json) {
    return UserInteractionEntity(
      id: json['id'],
      user_id: json['user_id'],
      article_id: json['article_id'],
      type: InteractionType.values.byName(json['interaction_type']),
      read_time: json['read_time'],
      read_duration: json['read_duration'],
    );
  }

  UserInteraction toModel() {
    return UserInteraction(
      id: id,
      userId: user_id,
      articleId: article_id,
      type: type,
      readTime: read_time,
      readDuration: read_duration,
    );
  }
}
