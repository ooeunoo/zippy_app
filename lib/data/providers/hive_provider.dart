// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:zippy/data/entity/user_category_entity.dart';

String USER_BOOKMARKS_BOX = 'USER_BOOKMARKS';
String USER_CATEGORIES_BOX = 'USER_CATEGORIES';

class HiveProvider {
  Box<dynamic>? userBookMarks;
  Box<dynamic>? userCategories;

  init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserBookmarkEntityAdapter());
    Hive.registerAdapter(UserCategoryEntityAdapter());
  }

  openBox() async {
    userBookMarks = await Hive.openBox(USER_BOOKMARKS_BOX);
    userCategories = await Hive.openBox(USER_CATEGORIES_BOX);
    // await Hive.box(USER_CATEGORIES_BOX).clear();
    // await Hive.box(USER_BOOKMARKS_BOX).clear();
  }
}
