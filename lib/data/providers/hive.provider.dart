// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';

String APP_METADATA_BOX = 'APP_METADATA';
String USER_BOOKMARKS_BOX = 'USER_BOOKMARKS';
String USER_BOOKMARK_FOLDERS_BOX = 'USER_BOOKMARK_FOLDERS';

class HiveProvider {
  Box<dynamic>? appMetadata;
  Box<dynamic>? userBookMarks;
  Box<dynamic>? userBookmarkFolders;

  init() async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk(APP_METADATA_BOX);
    await Hive.deleteBoxFromDisk(USER_BOOKMARKS_BOX);
    await Hive.deleteBoxFromDisk(USER_BOOKMARK_FOLDERS_BOX);
    // // 기존 어댑터 삭제 및 재등록
    Hive.registerAdapter(AppMetadataEntityAdapter());
    Hive.registerAdapter(UserBookmarkEntityAdapter());
    Hive.registerAdapter(UserBookmarkFolderEntityAdapter());
  }

  openBox() async {
    appMetadata = await Hive.openBox(APP_METADATA_BOX);
    userBookMarks = await Hive.openBox(USER_BOOKMARKS_BOX);
    userBookmarkFolders = await Hive.openBox(USER_BOOKMARK_FOLDERS_BOX);
  }

  closeBox() async {
    await appMetadata?.close();
    await userBookMarks?.close();
    await userBookmarkFolders?.close();
  }

  // 데이터 초기화 메서드
  Future<void> clearAllData() async {
    try {
      await appMetadata?.clear();
      await userBookMarks?.clear();
      await userBookmarkFolders?.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
