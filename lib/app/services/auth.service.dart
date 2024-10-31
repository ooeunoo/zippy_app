import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
import 'package:zippy/domain/usecases/get_current_user.usecase.dart';
import 'package:zippy/domain/usecases/logout.usecase.dart';
import 'package:zippy/domain/usecases/subscribe_auth_status.usecase.dart';
import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';

class AuthService extends GetxService {
  // final AuthDatasource _authDatasource = Get.find();
  final GetCurrentUser _getCurrentUser = Get.find();
  final SubscribeAuthStatus _subscribeAuthStatus = Get.find();
  final GetAppMetadata _getAppMetadata = Get.find();
  final UpdateAppMetadata _updateAppMetadata = Get.find();
  final Logout _logout = Get.find();
  // 상태 관리용 변수들
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  RxBool get isLoggedIn => RxBool(currentUser.value != null);

  AuthService();

  @override
  void onInit() {
    super.onInit();
    // 초기 사용자 상태 로드
    _loadCurrentUser();

    // 인증 상태 변화 구독
    _subscribeAuthStatus.execute().listen((user) {
      print('authStateChanges: $user');
      currentUser.value = user;
    });
  }

  Future<void> _loadCurrentUser() async {
    isLoading.value = true;
    try {
      final result = await _getCurrentUser.execute();
      print(result);
      result.fold((failure) => null, (user) => currentUser.value = user);
    } finally {
      isLoading.value = false;
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    isLoading.value = true;
    try {
      final result = await _logout.execute();
      result.fold((failure) => null, (success) {
        currentUser.value = null;
      });
    } finally {
      isLoading.value = false;
    }
  }
}
