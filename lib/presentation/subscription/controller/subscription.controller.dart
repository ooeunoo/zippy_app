import 'dart:async';

import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/params/create_user_subscription.params.dart';
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';

class SubscriptionController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final GetContentTypes getContentTypes;
  final CreateUserSubscription createUserSubscription;
  final DeleteUserSubscription deleteUserSubscription;
  final GetUserSubscriptions getUserSubscriptions;
  final SubscribeUserSubscriptions subscribeUserSubscriptions;

  SubscriptionController(
    this.getContentTypes,
    this.createUserSubscription,
    this.deleteUserSubscription,
    this.getUserSubscriptions,
    this.subscribeUserSubscriptions,
  );

  RxList<ContentType> contentTypes = RxList<ContentType>([]);
  RxList<UserSubscription> userSubscriptions = RxList<UserSubscription>([]);
  Rxn<String> error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  //////////////////////////////////////////////////////////////////
  /// public methods
  //////////////////////////////////////////////////////////////////

  Future<void> toggleSubscription(ContentType contentType) async {
    if (!authService.isLoggedIn.value) return;

    final userId = authService.currentUser.value!.id;
    final isSubscribed = isAlreadySubscription(contentType.id);

    // 낙관적 업데이트를 위한 현재 상태 백업
    final previousSubscriptions =
        List<UserSubscription>.from(userSubscriptions);

    try {
      if (isSubscribed) {
        // 낙관적으로 구독 제거
        userSubscriptions.removeWhere(
          (subscription) => subscription.contentTypeId == contentType.id,
        );

        // API 호출
        final result = await deleteUserSubscription.execute(contentType.id);
        result.fold(
          (failure) {
            // 실패시 롤백
            userSubscriptions.assignAll(previousSubscriptions);
            error.value = 'Failed to unsubscribe';
          },
          (_) => null, // 성공시 이미 UI가 업데이트된 상태
        );
      } else {
        // 낙관적으로 구독 추가
        final newSubscription = UserSubscription(
          id: DateTime.now().millisecondsSinceEpoch, // 임시 ID
          userId: userId,
          contentTypeId: contentType.id,
        );
        userSubscriptions.add(newSubscription);

        // API 호출
        final result = await createUserSubscription.execute(
          CreateUserSubscriptionParams(
            userId: userId,
            contentTypeId: contentType.id,
          ),
        );
        result.fold(
          (failure) {
            // 실패시 롤백
            userSubscriptions.assignAll(previousSubscriptions);
            error.value = 'Failed to subscribe';
          },
          (_) => null, // 성공시 이미 UI가 업데이트된 상태
        );
      }
    } catch (e) {
      // 예외 발생시 롤백
      userSubscriptions.assignAll(previousSubscriptions);
      error.value = 'Failed to update subscription';
    }
  }

  bool isAlreadySubscription(int contentTypeId) {
    return userSubscriptions
        .any((subscription) => subscription.contentTypeId == contentTypeId);
  }

  //////////////////////////////////////////////////////////////////
  /// initialize
  //////////////////////////////////////////////////////////////////

  Future<void> _initialize() async {
    await _setupContentTypes();

    // AuthService의 currentUser 변경 감지
    ever(authService.currentUser, _handleUserChange);

    // 초기 상태 처리
    _handleUserChange(authService.currentUser.value);
  }

  void _handleUserChange(User? newUser) async {
    if (newUser != null) {
      await _initializeUserDependentData();
    } else {
      _clearUserDependentData();
    }
  }

  Future<void> _initializeUserDependentData() async {
    await _setupUserSubscriptions();
    // _startUserSubscriptionsStream();
  }

  void _clearUserDependentData() {
    userSubscriptions.clear();
  }

  //////////////////////////////////////////////////////////////////
  /// setup
  //////////////////////////////////////////////////////////////////

  Future<void> _setupContentTypes() async {
    try {
      final result = await getContentTypes.execute();
      result.fold(
        (failure) {
          if (failure == ServerFailure()) {
            error.value = 'Error Fetching content types!';
          }
        },
        (data) => contentTypes.assignAll(data),
      );
    } catch (e) {
      error.value = 'Failed to load content types';
    }
  }

  Future<void> _setupUserSubscriptions() async {
    if (!authService.isLoggedIn.value) return;

    try {
      final subscriptions = await getUserSubscriptions.execute();
      subscriptions.fold(
        (failure) {
          if (failure == ServerFailure()) {
            error.value = 'Error Fetching subscriptions!';
          }
        },
        (data) => userSubscriptions.assignAll(data),
      );
    } catch (e) {
      error.value = 'Failed to load user subscriptions';
    }
  }
}
