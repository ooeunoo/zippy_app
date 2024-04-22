import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_communities.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SubscribeItems>(SubscribeItems(Get.find()));
    Get.put<GetCommunites>(GetCommunites(Get.find()));
    Get.put<GetCategories>(GetCategories(Get.find()));
    Get.put<GetBookmarksByUserId>(GetBookmarksByUserId(Get.find()));
    Get.put<CreateBookmark>(CreateBookmark(Get.find()));
    Get.put<DeleteBookmark>(DeleteBookmark(Get.find()));

    Get.put<BoardController>(
      BoardController(Get.find(), Get.find(), Get.find(), Get.find(),
          Get.find(), Get.find()),
    );
  }
}
