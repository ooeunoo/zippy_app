import 'package:zippy/data/sources/implementations/bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/channel_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/item_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/data/sources/interfaces/item_data_source.dart';
import 'package:zippy/domain/repositories/implementations/bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/channel;_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/item_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';
import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(BaseController(), permanent: true);

    Get.put<ChannelDatasource>(ChannelDatasourceIml(), permanent: true);
    Get.put<ChannelRepository>(ChannelRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<CategoryDatasource>(CategoryDatasourceIml(), permanent: true);
    Get.put<CategoryRepository>(CategoryRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<ItemDatasource>(ItemDatasourceImpl(), permanent: true);
    Get.put<ItemRepository>(ItemRepositoryImpl(Get.find()), permanent: true);

    Get.put<BookmarkDatasource>(BookmarkDatasourceIml(), permanent: true);
    Get.put<BookmarkRepository>(BookmarkRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<SubscribeItems>(SubscribeItems(Get.find()));
    Get.put<GetChannels>(GetChannels(Get.find()));
    Get.put<GetCategories>(GetCategories(Get.find()));
    Get.put<GetBookmarksByUserId>(GetBookmarksByUserId(Get.find()));
    Get.put<CreateBookmark>(CreateBookmark(Get.find()));
    Get.put<DeleteBookmark>(DeleteBookmark(Get.find()));
    Get.put<GetUserChannelByUserId>(GetUserChannelByUserId(Get.find()));

    Get.lazyPut<BoardController>(
      () => BoardController(Get.find(), Get.find(), Get.find(), Get.find(),
          Get.find(), Get.find(), Get.find()),
    );
  }
}
