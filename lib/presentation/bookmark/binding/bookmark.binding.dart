import 'package:get/get.dart';
import 'package:zippy/data/sources/bookmark.source.dart';
import 'package:zippy/domain/repositories/bookmark.repository.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/presentation/bookmark/controller/bookmark.controller.dart';

class BookmarkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceImpl());
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<GetUserBookmark>(() => GetUserBookmark(Get.find()));
    Get.lazyPut<DeleteUserBookmark>(() => DeleteUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserBookmark>(() => SubscribeUserBookmark(Get.find()));

    Get.lazyPut<BookmarkController>(
        () => BookmarkController(Get.find(), Get.find(), Get.find()));
  }
}
