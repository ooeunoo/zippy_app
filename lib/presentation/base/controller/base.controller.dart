import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/utils/vibrates.dart';

class BaseController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  onInit() async {
    super.onInit();
  }

  void changeTab(int index) {
    currentIndex.value = index;
    onHeavyVibration();
    switch (index) {
      case 0:
        Get.toNamed(Routes.board, id: 1);
        break;
      case 1:
        Get.toNamed(Routes.profile, id: 1);
        break;
    }
  }
}
