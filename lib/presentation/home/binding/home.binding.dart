import 'package:get/get.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
