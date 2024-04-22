import 'package:zippy/domain/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_community.dart';

@immutable
class UserCommunityEntity extends Equatable {
  final int? id;
  final String user_id;
  final int community_id;

  const UserCommunityEntity({
    this.id,
    required this.user_id,
    required this.community_id,
  });

  @override
  List<Object> get props {
    return [user_id, community_id];
  }

  factory UserCommunityEntity.fromJson(Map<String, dynamic> json) {
    return UserCommunityEntity(
      id: json['id'],
      user_id: json['user_id'],
      community_id: json['community_id'],
    );
  }

  dynamic toParams() => {
        'user_id': user_id,
        'community_id': community_id,
      };

  UserCommunity toModel() {
    return UserCommunity(
      id: id,
      userId: user_id,
      communityId: community_id,
    );
  }
}
