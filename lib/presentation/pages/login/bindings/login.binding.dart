import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/auth/auth.controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
