import 'package:zippy/presentation/base/controller/base.controller.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BoardController>(BoardController(), permanent: true);
    Get.put<BaseController>(BaseController(), permanent: true);
  }
}
