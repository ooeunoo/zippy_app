import 'package:cocomu/data/repositories/community_repository_impl.dart';
import 'package:cocomu/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BoardController>(BoardController(), permanent: true);
  }
}
