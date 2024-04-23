import 'dart:ffi';

import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';

class BookmarkController extends GetxController {
  final authController = Get.find<AuthController>();

  final GetBookmarksByUserId getBookmarksByUserId;

  BookmarkController(this.getBookmarksByUserId);

  RxList<Bookmark> bookmarks = RxList<Bookmark>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    await _setupBookmarks();

    ever(error, (e) => print(e));
  }

  _setupBookmarks() async {
    UserModel? user = authController.user.value;
    if (user != null) {
      final result =
          await getBookmarksByUserId.execute(user.id, withItem: true);
      result.fold((failure) {
        if (failure == ServerFailure()) {
          error.value = 'Error Fetching Bookmark!';
        }
      }, (data) {
        List<Bookmark> list = [];
        for (var bookmark in data) {
          list.add(bookmark);
        }
        bookmarks.assignAll(list);
      });
    }
  }
}
