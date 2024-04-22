import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/user_community_entity.dart';

@immutable
class UserCommunity extends Equatable {
  final int? id;
  final String userId;
  final int communityId;

  const UserCommunity({
    this.id,
    required this.userId,
    required this.communityId,
  });

  @override
  List<Object> get props {
    return [userId, communityId];
  }

  dynamic toJson() => {
        'id': id,
        'userId': userId,
        'communityId': communityId,
      };

  UserCommunityEntity toCreateEntity() =>
      UserCommunityEntity(user_id: userId, community_id: communityId);

  @override
  String toString() {
    return toJson().toString();
  }
}
