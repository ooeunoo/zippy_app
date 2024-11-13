import 'package:get/get.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoardController>(() => BoardController());
  }
}
