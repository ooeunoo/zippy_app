import 'package:zippy/domain/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_channel.dart';

@immutable
class UserChannelEntity extends Equatable {
  final int? id;
  final String user_id;
  final int channel_id;

  const UserChannelEntity({
    this.id,
    required this.user_id,
    required this.channel_id,
  });

  @override
  List<Object> get props {
    return [user_id, channel_id];
  }

  factory UserChannelEntity.fromJson(Map<String, dynamic> json) {
    return UserChannelEntity(
      id: json['id'],
      user_id: json['user_id'],
      channel_id: json['channel_id'],
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'channel_id': channel_id,
      };

  UserChannel toModel() {
    return UserChannel(
      id: id,
      userId: user_id,
      channelId: channel_id,
    );
  }
}
