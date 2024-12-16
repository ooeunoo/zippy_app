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
  }

  Future<void> openBox() async {
    if (appMetadata == null || !appMetadata!.isOpen) {
      appMetadata = await Hive.openBox(APP_METADATA);
      // 데이터 영속성 보장을 위한 flush
      await appMetadata?.flush();
    }
  }

  Future<void> closeBox() async {
    if (appMetadata != null && appMetadata!.isOpen) {
      // 닫기 전에 데이터 영속화 보장
      await appMetadata?.flush();
      await appMetadata?.close();
    }
  }

  // 데이터 초기화 메서드
  Future<void> clearAllData() async {
    try {
      await openBox(); // 박스가 닫혀있을 수 있으므로 먼저 열기 시도
      await appMetadata?.clear();
      await appMetadata?.flush(); // 클리어 후 변경사항 즉시 저장
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // 데이터 즉시 저장 메서드
  Future<void> flushData() async {
    try {
      if (appMetadata != null && appMetadata!.isOpen) {
        await appMetadata?.flush();
      }
    } catch (e) {
      print('Error flushing data: $e');
    }
  }
}
