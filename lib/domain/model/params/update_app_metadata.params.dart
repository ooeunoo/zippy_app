import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UpdateAppMetadataParams extends Equatable {
  final bool? lookaround;
  final ThemeMode? themeMode;
  final bool? onBoardingBoardPage;

  const UpdateAppMetadataParams({
    this.lookaround,
    this.themeMode,
    this.onBoardingBoardPage,
  });

  @override
  List<Object?> get props => [lookaround, themeMode, onBoardingBoardPage];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (lookaround != null) {
      data['lookaround'] = lookaround;
    }

    if (themeMode != null) {
      data['themeMode'] = themeMode.toString().split('.').last.toLowerCase();
    }

    if (onBoardingBoardPage != null) {
      data['onBoardingBoardPage'] = onBoardingBoardPage;
    }

    return data;
  }

  @override
  String toString() => toJson().toString();
}
