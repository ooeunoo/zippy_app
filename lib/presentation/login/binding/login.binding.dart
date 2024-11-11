import 'package:get/get.dart';
import 'package:zippy/domain/usecases/login_with_kakao.usecase.dart';
import 'package:zippy/presentation/login/controller/login.controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginWithKakao(Get.find()));
    Get.lazyPut(() => LoginController(Get.find()));
  }
}
