// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';

String USER_BOOKMARKS_BOX = 'USER_BOOKMARKS';
String USER_SUBSCRIPTIONS_BOX = 'USER_SUBSCRIPTIONS';

class HiveProvider {
  Box<dynamic>? userBookMarks;
  Box<dynamic>? userSubscriptions;
  init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserBookmarkEntityAdapter());
    Hive.registerAdapter(UserSubscriptionEntityAdapter());
  }

  openBox() async {
    userBookMarks = await Hive.openBox(USER_BOOKMARKS_BOX);
    userSubscriptions = await Hive.openBox(USER_SUBSCRIPTIONS_BOX);
  }

  closeBox() async {
    await userBookMarks?.close();
    await userSubscriptions?.close();
  }
}
