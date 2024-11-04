import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/user_interaction.model.dart';

@immutable
class UserInteractionEntity extends Equatable {
  final int? id;
  final String user_id;
  final int article_id;
  final InteractionType type;
  final int? read_percent;
  final int? read_duration;

  const UserInteractionEntity({
    this.id,
    required this.user_id,
    required this.article_id,
    required this.type,
    this.read_percent,
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
      read_percent: json['read_percent'],
      read_duration: json['read_duration'],
    );
  }

  UserInteraction toModel() {
    return UserInteraction(
      id: id,
      userId: user_id,
      articleId: article_id,
      type: type,
      readPercent: read_percent,
      readDuration: read_duration,
    );
  }
}
