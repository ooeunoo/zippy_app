import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UpdateAppMetadataParams extends Equatable {
  final bool? lookaround;
  final ThemeMode? themeMode;
  final bool? onBoardingBoardPage;
  final bool? onBoardingBookmarkPage;

  const UpdateAppMetadataParams({
    this.lookaround,
    this.themeMode,
    this.onBoardingBoardPage,
    this.onBoardingBookmarkPage,
  });

  @override
  List<Object?> get props => [
        lookaround,
        themeMode,
        onBoardingBoardPage,
        onBoardingBookmarkPage,
      ];

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

    if (onBoardingBookmarkPage != null) {
      data['onBoardingBookmarkPage'] = onBoardingBookmarkPage;
    }

    return data;
  }

  @override
  String toString() => toJson().toString();
}
