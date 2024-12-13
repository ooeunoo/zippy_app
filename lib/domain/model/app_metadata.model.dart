import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';

@immutable
class AppMetadata extends Equatable {
  final bool lookaround;
  final ThemeMode themeMode;
  final bool onBoardingBoardPage;
  final bool onBoardingBookmarkPage;

  const AppMetadata({
    required this.lookaround,
    required this.themeMode,
    required this.onBoardingBoardPage,
    required this.onBoardingBookmarkPage,
  });

  @override
  List<Object> get props {
    return [
      lookaround,
      themeMode,
      onBoardingBoardPage,
      onBoardingBookmarkPage,
    ];
  }

  dynamic toJson() => {
        'lookaround': lookaround,
        'themeMode': themeMode.toString().split('.').last.toLowerCase(),
        'onBoardingBoardPage': onBoardingBoardPage,
        'onBoardingBookmarkPage': onBoardingBookmarkPage,
      };

  AppMetadataEntity toCreateEntity() => AppMetadataEntity(
        lookaround: lookaround,
        themeMode: themeMode.toString().split('.').last.toLowerCase(),
        onBoardingBoardPage: onBoardingBoardPage,
        onBoardingBookmarkPage: onBoardingBookmarkPage,
      );

  @override
  String toString() {
    return toJson().toString();
  }
}
