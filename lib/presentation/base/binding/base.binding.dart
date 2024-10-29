import 'package:zippy/presentation/base/controller/base.controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(BaseController(), permanent: true);
  }
}
