import 'package:zippy/data/sources/implementations/bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/domain/repositories/implementations/bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/bookmark/bookmark_controller.dart';

class BookmarkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceIml());
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));
    Get.lazyPut<GetBookmarksByUserId>(() => GetBookmarksByUserId(Get.find()));
    Get.lazyPut<BookmarkController>(() => BookmarkController(Get.find()));
  }
}
