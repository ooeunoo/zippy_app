import 'package:cocomu/domain/usecases/get_categories.dart';
import 'package:cocomu/domain/usecases/get_communities.dart';
import 'package:cocomu/domain/usecases/subscirbe_items.dart';
import 'package:cocomu/presentation/controllers/base/base_controller.dart';
import 'package:cocomu/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SubscribeItems>(SubscribeItems(Get.find()));
    Get.put<GetCommunites>(GetCommunites(Get.find()));
    Get.put<GetCategories>(GetCategories(Get.find()));

    Get.put<BoardController>(
      BoardController(Get.find(), Get.find(), Get.find()),
    );
  }
}
