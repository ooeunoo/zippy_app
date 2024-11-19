import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/params/create_or_delete_user_subscription.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/listen_user_subscription_changes.usecase.dart';

class SubscriptionService extends GetxService {
  final AuthService authService = Get.find<AuthService>();

  final GetContentTypes getContentTypes = Get.find<GetContentTypes>();
  final CreateUserSubscription createUserSubscription =
      Get.find<CreateUserSubscription>();
  final DeleteUserSubscription deleteUserSubscription =
      Get.find<DeleteUserSubscription>();
  final GetUserSubscriptions getUserSubscriptions =
      Get.find<GetUserSubscriptions>();
  final ListenUserSubscriptionChanges listenUserSubscriptionChanges =
      Get.find<ListenUserSubscriptionChanges>();

  RxList<ContentType> contentTypes = RxList<ContentType>([]);
  RxList<UserSubscription> userSubscriptions = RxList<UserSubscription>([]);
  Rxn<String> error = Rxn<String>();
  RxBool isLoadingUserSubscription = RxBool(true);
  StreamSubscription? userSubscription;
  RealtimeChannel? _userSubscriptionsChannel;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  //////////////////////////////////////////////////////////////////
  /// public methods
  //////////////////////////////////////////////////////////////////

  Future<void> onHandleToggleSubscription(ContentType contentType) async {
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
        final result = await deleteUserSubscription.execute(
          CreateOrDeleteUserSubscriptionParams(
            userId: userId,
            contentTypeId: contentType.id,
          ),
        );
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
          CreateOrDeleteUserSubscriptionParams(
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

//////////////////////////////////////////////////////////////////
  /// setup
//////////////////////////////////////////////////////////////////
  _initialize() {
    _fetchUserSubscriptions();
    _listenUser();
  }

  void _listenUser() {
    ever(authService.currentUser, (user) {
      print("user: $user");
      _cancelSubscriptions();
      if (user != null) {
        print("user: $user");
        _setupSubscriptions();
        _fetchUserSubscriptions();
      }
    });
  }

  void _cancelSubscriptions() {
    _userSubscriptionsChannel?.unsubscribe();
    _userSubscriptionsChannel = null;
  }

  void _setupSubscriptions() {
    if (authService.currentUser.value != null) {
      final channel = listenUserSubscriptionChanges
          .execute(authService.currentUser.value!.id, () {
        _fetchUserSubscriptions();
      });
      _userSubscriptionsChannel = channel;
      _userSubscriptionsChannel?.subscribe();
    }
  }

  Future<void> _fetchUserSubscriptions() async {
    if (!authService.isLoggedIn.value) return;

    try {
      final subscriptions =
          await getUserSubscriptions.execute(authService.currentUser.value!.id);
      subscriptions.fold(
        (failure) {
          if (failure == ServerFailure()) {
            error.value = 'Error Fetching subscriptions!';
          }
        },
        (data) {
          print("fetched: $data");
          userSubscriptions.assignAll(data);
        },
      );
    } catch (e) {
      error.value = 'Failed to load user subscriptions';
    }
  }
}
