import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String nickname;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.nickname,
  });

  @override
  List<Object> get props {
    return [id, email, name, nickname];
  }

  dynamic toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'nickname': nickname,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
