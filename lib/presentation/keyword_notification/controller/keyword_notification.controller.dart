import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_snak_bar.dart';
import 'package:zippy/domain/model/params/create_user_keyword_notification.params.dart';
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/model/user_keyword_notification.model.dart';
import 'package:zippy/domain/usecases/create_user_keyword_notification.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_keyword_notification.usecase.dart';
import 'package:zippy/domain/usecases/get_user_keyword_notifications.usecase.dart';
import 'package:zippy/domain/usecases/toggle_user_keyword_notification.usecase.dart';

class KeywordNotificationController extends GetxController {
  final AuthService authService = Get.find();
  final GetUserKeywordNotifications getUserKeywordNotifications = Get.find();
  final ToggleUserKeywordNotification toggleUserKeywordNotification =
      Get.find();
  final CreateUserKeywordNotification createUserKeywordNotification =
      Get.find();
  final DeleteUserKeywordNotification deleteUserKeywordNotification =
      Get.find();

  RxList<UserKeywordNotification> userKeywordNotifications = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    _fetchUserKeywordNotifications();
  }

  Future<void> _fetchUserKeywordNotifications() async {
    User? user = authService.currentUser.value;
    if (user == null) return;

    final result = await getUserKeywordNotifications.execute(user.id);
    result.fold((failure) {
      userKeywordNotifications.value = [];
    }, (notifications) {
      userKeywordNotifications.value = notifications;
    });
  }

  Future<void> onHandleToggleOrCreateNotification(String keyword) async {
    User? user = authService.currentUser.value;
    if (user == null) return;

    // Check if notification already exists
    final existingNotification =
        userKeywordNotifications.firstWhereOrNull((n) => n.keyword == keyword);

    if (existingNotification != null) {
      // Toggle existing notification
      await toggleNotification(existingNotification);
    } else {
      // Create new notification
      await onHandleCreateNotification(keyword);
    }

    _fetchUserKeywordNotifications();
  }

  Future<void> toggleNotification(UserKeywordNotification notification) async {
    final result = await toggleUserKeywordNotification.execute(
      notification.id,
      !notification.isActive,
    );

    result.fold((failure) {}, (_) {
      _fetchUserKeywordNotifications();
    });
  }

  Future<void> onHandleCreateNotification(String keyword) async {
    User? user = authService.currentUser.value;
    if (user == null) return;

    final params = CreateUserKeywordNotificationParams(
      userId: user.id,
      keyword: keyword,
      isActive: true,
    );

    if (keyword.isEmpty) return;
    if (userKeywordNotifications.any((n) => n.keyword == keyword)) {
      notifyAlreadyExists();
      return;
    }

    final result = await createUserKeywordNotification.execute(params);

    result.fold((failure) {}, (_) {
      _fetchUserKeywordNotifications();
    });
  }

  Future<void> onHandleDeleteNotification(
      UserKeywordNotification notification) async {
    final result = await deleteUserKeywordNotification.execute(notification.id);

    result.fold((failure) {}, (_) {
      _fetchUserKeywordNotifications();
    });
  }
}
