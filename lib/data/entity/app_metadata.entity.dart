import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';

part 'app_metadata.entity.g.dart';

@HiveType(typeId: Constants.appMetadataHiveId)
class AppMetadataEntity extends HiveObject {
  @HiveField(0)
  bool lookaround;

  @HiveField(1)
  String themeMode;

  @HiveField(2)
  bool onBoardingBoardPage;

  @HiveField(3)
  bool onBoardingBookmarkPage;

  AppMetadataEntity({
    required this.lookaround,
    this.themeMode = 'system',
    this.onBoardingBoardPage = false,
    this.onBoardingBookmarkPage = false,
  });

  AppMetadata toModel() {
    return AppMetadata(
      lookaround: lookaround,
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.toString().split('.').last.toLowerCase() == themeMode,
        orElse: () => ThemeMode.system,
      ),
      onBoardingBoardPage: onBoardingBoardPage,
      onBoardingBookmarkPage: onBoardingBookmarkPage,
    );
  }
}
