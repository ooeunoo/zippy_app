import 'package:get/get.dart';
import 'package:zippy/domain/usecases/create_user_feedback.usecase.dart';
import 'package:zippy/presentation/profile/controller/profile.controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateUserFeedback(Get.find()));
    Get.lazyPut(() => ProfileController());
  }
}
