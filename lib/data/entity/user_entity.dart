import 'package:zippy/domain/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String provider;

  const UserEntity(
      {required this.id,
      required this.email,
      required this.name,
      required this.provider});

  @override
  List<Object> get props {
    return [id, email, name, provider];
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      provider: json['provider'],
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      provider: provider,
    );
  }
}
