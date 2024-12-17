import 'package:get/get.dart';
import 'package:zippy/data/sources/user_keyword_notification.source.dart';
import 'package:zippy/domain/repositories/user_keyword_notification.repository.dart';
import 'package:zippy/domain/usecases/create_user_keyword_notification.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_keyword_notification.usecase.dart';
import 'package:zippy/domain/usecases/get_user_keyword_notifications.usecase.dart';
import 'package:zippy/domain/usecases/toggle_user_keyword_notification.usecase.dart';
import 'package:zippy/presentation/keyword_notification/controller/keyword_notification.controller.dart';

class KeywordNotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserKeywordNotificationDatasourceImpl());
    Get.lazyPut(() => UserKeywordNotificationRepositoryImpl(
        UserKeywordNotificationDatasourceImpl()));
    Get.lazyPut(() => GetUserKeywordNotifications(
        UserKeywordNotificationRepositoryImpl(
            UserKeywordNotificationDatasourceImpl())));
    Get.lazyPut(() => ToggleUserKeywordNotification(
        UserKeywordNotificationRepositoryImpl(
            UserKeywordNotificationDatasourceImpl())));
    Get.lazyPut(() => CreateUserKeywordNotification(
        UserKeywordNotificationRepositoryImpl(
            UserKeywordNotificationDatasourceImpl())));
    Get.lazyPut(() => DeleteUserKeywordNotification(
        UserKeywordNotificationRepositoryImpl(
            UserKeywordNotificationDatasourceImpl())));
    Get.lazyPut(() => KeywordNotificationController());
  }
}
