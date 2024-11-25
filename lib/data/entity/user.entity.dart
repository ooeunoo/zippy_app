import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/utils/log.dart';
import 'package:zippy/domain/enum/oauth_provider._type.enum.dart';
import 'package:zippy/domain/model/user.model.dart';

@immutable
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final int? avatar_index;
  final OAuthProviderType provider;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatar_index,
    required this.provider,
  });

  @override
  List<Object> get props {
    return [
      id,
      email,
      provider,
    ];
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar_index: json['avatar_index'],
      provider: OAuthProviderType.values.byName(json['provider']),
    );
  }

  User toModel() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarIndex: avatar_index,
      provider: provider,
    );
  }
}
