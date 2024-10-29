import 'package:get/get.dart';
import 'package:zippy/presentation/login/controller/login.controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
