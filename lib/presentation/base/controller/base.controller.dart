import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';

class BaseController extends GetxController {
  final BoardController boardController = Get.find<BoardController>();

  RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    // if (currentIndex.value == index) return;
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed(
          Routes.home,
          id: 1,
          preventDuplicates: false,
        );
        break;
      case 1:
        if (index == 1) {
          boardController.onHandleFetchRandomArticles();
        }

        Get.toNamed(
          Routes.board,
          id: 1,
          preventDuplicates: false,
        );
        break;
      case 2:
        Get.toNamed(
          Routes.search,
          id: 1,
          preventDuplicates: false,
        );
        break;
      case 3:
        Get.toNamed(
          Routes.profile,
          id: 1,
          preventDuplicates: false,
        );
        break;
    }
  }
}
