import 'package:get/get.dart';
import 'package:zippy/presentation/profile/controller/profile.controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
