import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/utils/log.dart';
import 'package:zippy/domain/model/user.model.dart';

@immutable
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  List<Object> get props {
    return [
      id,
      email,
      name,
    ];
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  User toModel() {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }
}
