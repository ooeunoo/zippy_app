import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/usecases/get_user.dart';
import 'package:zippy/domain/usecases/login_with_google.dart';
import 'package:zippy/domain/usecases/login_with_kakao.dart';
import 'package:zippy/domain/usecases/login_with_naver.dart';
import 'package:zippy/domain/usecases/logout.dart';
import 'package:zippy/domain/usecases/subscirbe_user.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SubscribeUser subscribeUser;
  final LoginWithNaver loginWithNaver;
  final LoginWithGoogle loginWithGoogle;
  final LoginWithKakao loginWithKakao;
  final Logout logout;

  final GetUser getUser;

  AuthController(this.getUser, this.loginWithKakao, this.logout,
      this.subscribeUser, this.loginWithNaver, this.loginWithGoogle);

  Rxn<UserModel> user = Rxn<UserModel>().obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() {
    super.onInit();
    _subscribeUser().listen((user) async {
      await _refreshUser(user);
      await _navigateDependUser(user);
    });
  }

  Future<void> loginWithNaverUser() async {
    final result = await loginWithNaver.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Fail to login with naver";
      } else if (failure == AlreadyRegisteredUserEmailFailure()) {
        notifyAlreadyRegisteredUserEmail();
      }
    }, (data) {
      return true;
    });
  }

  Future<void> loginWithKakaoUser() async {
    final result = await loginWithKakao.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Fail to login with kakao";
      } else if (failure == AlreadyRegisteredUserEmailFailure()) {
        notifyAlreadyRegisteredUserEmail();
      }
    }, (data) {
      return true;
    });
  }

  Future<void> loginWithGoogleUser() async {
    final result = await loginWithGoogle.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Fail to login with google";
      } else if (failure == AlreadyRegisteredUserEmailFailure()) {
        notifyAlreadyRegisteredUserEmail();
      }
    }, (data) {
      return true;
    });
  }

  logoutUser() async {
    logout.execute();
  }

  Stream<User?> _subscribeUser() {
    Stream<User?> result = subscribeUser.execute();
    return result;
  }

  UserModel? getSignedUser() {
    return user.value;
  }

  Future<void> _refreshUser(User? data) async {
    if (data == null) {
      user.value = null;
    } else {
      String userId = data.id;
      final result = await getUser.execute(userId);

      result.fold((failure) {
        if (failure == ServerFailure()) {
          error.value = "Error Fetching user!";
        }
      }, (response) {
        user.value = response;
      });
    }
  }

  _navigateDependUser(user) {
    if (user == null) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.base);
    }
  }
}
