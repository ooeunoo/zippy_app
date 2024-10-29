// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';

String APP_METADATA_BOX = 'APP_METADATA';
String USER_BOOKMARKS_BOX = 'USER_BOOKMARKS';
String USER_SUBSCRIPTIONS_BOX = 'USER_SUBSCRIPTIONS';

class HiveProvider {
  Box<dynamic>? appMetadata;
  Box<dynamic>? userBookMarks;
  Box<dynamic>? userSubscriptions;

  init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AppMetadataEntityAdapter());
    Hive.registerAdapter(UserBookmarkEntityAdapter());
    Hive.registerAdapter(UserSubscriptionEntityAdapter());
  }

  openBox() async {
    appMetadata = await Hive.openBox(APP_METADATA_BOX);
    userBookMarks = await Hive.openBox(USER_BOOKMARKS_BOX);
    userSubscriptions = await Hive.openBox(USER_SUBSCRIPTIONS_BOX);
  }

  closeBox() async {
    await appMetadata?.close();
    await userBookMarks?.close();
    await userSubscriptions?.close();
  }
}
