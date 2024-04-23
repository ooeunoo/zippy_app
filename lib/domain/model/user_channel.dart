import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';

@immutable
class UserChannel extends Equatable {
  final int? id;
  final String userId;
  final int channelId;

  const UserChannel({
    this.id,
    required this.userId,
    required this.channelId,
  });

  @override
  List<Object> get props {
    return [userId, channelId];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'channelId': channelId,
      };

  UserChannelEntity toCreateEntity() =>
      UserChannelEntity(user_id: userId, channel_id: channelId);

  @override
  String toString() {
    return toJson().toString();
  }
}
