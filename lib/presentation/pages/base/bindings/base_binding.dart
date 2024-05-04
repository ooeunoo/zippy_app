import 'package:zippy/data/sources/implementations/bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/channel_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/content_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_category_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/data/sources/interfaces/content_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_bookmark_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_category_data_source.dart';
import 'package:zippy/domain/repositories/implementations/bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/channel;_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/content_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_category_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:zippy/domain/repositories/interfaces/content_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_bookmark_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_category_repository.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.dart';
import 'package:zippy/domain/usecases/get_user_category.dart';
import 'package:zippy/domain/usecases/subscirbe_contents.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_category%20.dart';
import 'package:zippy/domain/usecases/up_content_report_count.dart';
import 'package:zippy/domain/usecases/up_content_view_count.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(BaseController(), permanent: true);

    Get.lazyPut<ChannelDatasource>(() => ChannelDatasourceIml());
    Get.lazyPut<ChannelRepository>(() => ChannelRepositoryImpl(Get.find()));

    Get.lazyPut<CategoryDatasource>(() => CategoryDatasourceIml());
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));

    Get.lazyPut<ContentDatasource>(() => ContentDatasourceImpl());
    Get.lazyPut<ContentRepository>(() => ContentRepositoryImpl(Get.find()));

    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceIml());
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<UserCategoryDatasource>(() => UserCategoryDatasourceImpl());
    Get.lazyPut<UserCategoryRepository>(
        () => UserCategoryRepositoryImpl(Get.find()));

    Get.lazyPut<UserBookmarkDatasource>(() => UserBookmarkDatasourceImpl());
    Get.lazyPut<UserBookmarkRepository>(
        () => UserBookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<SubscribeContents>(() => SubscribeContents(Get.find()));
    Get.lazyPut<GetChannels>(() => GetChannels(Get.find()));
    Get.lazyPut<GetCategories>(() => GetCategories(Get.find()));
    Get.lazyPut<GetUserBookmark>(() => GetUserBookmark(Get.find()));
    Get.lazyPut<CreateUserBookmark>(() => CreateUserBookmark(Get.find()));
    Get.lazyPut<DeleteUserBookmark>(() => DeleteUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserBookmark>(() => SubscribeUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserCategory>(() => SubscribeUserCategory(Get.find()));
    Get.lazyPut<GetUserCategory>(() => GetUserCategory(Get.find()));
    Get.lazyPut<UpContentViewCount>(() => UpContentViewCount(Get.find()));
    Get.lazyPut<UpContentReportCount>(() => UpContentReportCount(Get.find()));

    Get.lazyPut<BoardController>(
      () => BoardController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find()),
    );
  }
}
