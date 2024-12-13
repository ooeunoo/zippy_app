import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UpdateAppMetadataParams extends Equatable {
  final bool? lookaround;
  final ThemeMode? themeMode;

  const UpdateAppMetadataParams({
    this.lookaround,
    this.themeMode,
  });

  @override
  List<Object?> get props => [lookaround, themeMode];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (lookaround != null) {
      data['lookaround'] = lookaround;
    }

    if (themeMode != null) {
      data['themeMode'] = themeMode.toString().split('.').last.toLowerCase();
    }

    return data;
  }

  @override
  String toString() => toJson().toString();
}
