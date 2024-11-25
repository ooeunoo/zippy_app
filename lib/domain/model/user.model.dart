import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/oauth_provider._type.enum.dart';

@immutable
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final int? avatarIndex;
  final OAuthProviderType provider;
  User({
    required this.id,
    required this.email,
    this.name,
    this.avatarIndex,
    required this.provider,
  });

  @override
  List<Object?> get props => [email, name, provider];

  dynamic toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar_index': avatarIndex,
        'provider': provider.name,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
