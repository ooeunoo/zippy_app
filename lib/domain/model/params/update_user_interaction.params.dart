import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UpdateUserInteractionParams extends Equatable {
  final int id;
  final int? readPercent;
  final int? readDuration;

  const UpdateUserInteractionParams({
    required this.id,
    this.readPercent = 0,
    this.readDuration = 0,
  });

  @override
  List<Object> get props {
    return [id];
  }

  Map<String, dynamic> toJson() => {
        'read_percent': readPercent,
        'read_duration': readDuration,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
