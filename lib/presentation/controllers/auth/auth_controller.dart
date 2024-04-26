import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/usecases/get_user.dart';
import 'package:zippy/domain/usecases/login_with_kakao.dart';
import 'package:zippy/domain/usecases/login_with_naver.dart';
import 'package:zippy/domain/usecases/logout.dart';
import 'package:zippy/domain/usecases/subscirbe_user.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SubscribeUser subscribeUser;
  final LoginWithNaver loginWithNaver;
  final LoginWithKakao loginWithKakao;
  final Logout logout;

  final GetUser getUser;

  AuthController(this.getUser, this.loginWithKakao, this.logout,
      this.subscribeUser, this.loginWithNaver);

  Rxn<UserModel> user = Rxn<UserModel>().obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() {
    super.onInit();
    _subscribeUser().listen((user) async {
      await _refreshUser(user);
      await _navigateDependUser(user);
    });

    // TODO: remove
    ever(error, (e) => print(e));
  }

  Future<void> loginWithNaverUser() async {
    final result = await loginWithNaver.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
      } else if (failure == AlreadyRegisteredUserEmailFailure()) {
        notifyAlreadyRegisteredUserEmail();
      }
    }, (data) {});
  }

  Future<void> loginWithKakaoUser() async {
    loginWithKakao.execute();
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
