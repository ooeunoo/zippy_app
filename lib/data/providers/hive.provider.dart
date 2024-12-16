// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';

String APP_METADATA = 'app_metadata';

class HiveProvider {
  Box<dynamic>? appMetadata;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppMetadataEntityAdapter());
    // // 기존 박스가 있다면 삭제
    // await Hive.deleteBoxFromDisk(APP_METADATA);

    // // 새로운 박스 열기
    // appMetadata = await Hive.openBox(APP_METADATA);

    // // 박스 클리어
    // await appMetadata?.clear();
  }

  openBox() async {
    appMetadata = await Hive.openBox(APP_METADATA);
  }

  closeBox() async {
    await appMetadata?.close();
  }

  // 데이터 초기화 메서드
  Future<void> clearAllData() async {
    try {
      await appMetadata?.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
