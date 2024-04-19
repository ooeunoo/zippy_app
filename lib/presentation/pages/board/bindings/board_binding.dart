import 'package:cocomu/domain/usecases/get_categories.dart';
import 'package:cocomu/domain/usecases/get_communities.dart';
import 'package:cocomu/domain/usecases/subscirbe_items.dart';
import 'package:cocomu/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscribeItems>(() => SubscribeItems(Get.find()));
    Get.lazyPut<GetCommunites>(() => GetCommunites(Get.find()));
    Get.lazyPut<GetCategories>(() => GetCategories(Get.find()));

    Get.lazyPut<BoardController>(
      () => BoardController(Get.find(), Get.find(), Get.find()),
    );
  }
}
