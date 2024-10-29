import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/profile/profile.controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
