import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UpdateAppMetadataParams extends Equatable {
  final bool? lookaround;

  const UpdateAppMetadataParams({
    this.lookaround,
  });

  @override
  List<Object?> get props => [lookaround];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (lookaround != null) {
      data['lookaround'] = lookaround;
    }

    return data;
  }

  @override
  String toString() => toJson().toString();
}
