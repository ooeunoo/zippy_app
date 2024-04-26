import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String provider;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
  });

  @override
  List<Object> get props {
    return [id, email, name, provider];
  }

  dynamic toJson() =>
      {'id': id, 'email': email, 'name': name, 'provider': provider};

  @override
  String toString() {
    return toJson().toString();
  }
}
