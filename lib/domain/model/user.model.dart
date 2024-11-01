import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? avatarIndex;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarIndex,
  });

  @override
  List<Object?> get props {
    return [email, name];
  }

  dynamic toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar_index': avatarIndex,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
