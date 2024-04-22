import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/app/routes/app_pages.dart';
import 'package:cocomu/data/entity/user_entity.dart';
import 'package:cocomu/domain/model/user.dart';
import 'package:cocomu/domain/usecases/get_user.dart';
import 'package:cocomu/domain/usecases/login_with_kakao.dart';
import 'package:cocomu/domain/usecases/logout.dart';
import 'package:cocomu/domain/usecases/subscirbe_user.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SubscribeUser subscribeUser;
  final LoginWithKakao loginWithKakao;
  final Logout logout;

  final GetUser getUser;

  AuthController(
      this.getUser, this.loginWithKakao, this.logout, this.subscribeUser);

  Rxn<UserModel> user = Rxn<UserModel>().obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    _subscribeUser().listen((event) {
      print(event);
    });
  }

  loginKakaoUser() async {
    loginWithKakao.execute();
  }

  logoutUser() async {
    logout.execute();
  }

  Stream<User?> _subscribeUser() {
    Stream<User?> result = subscribeUser.execute();
    return result;
  }

  _refreshUser(String id) async {
    final result = await getUser.execute(id);

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Customer!";
      }
    }, (data) {
      user.value = data;
    });
  }
}
