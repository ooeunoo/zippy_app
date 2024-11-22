import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CreateBookmarkFolderParams extends Equatable {
  final String userId;
  final String name;
  final String? description;

  const CreateBookmarkFolderParams({
    required this.userId,
    required this.name,
    this.description,
  });

  @override
  List<Object> get props {
    return [userId, name];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'description': description,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
