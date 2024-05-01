import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/user_bookmark.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';

class BookmarkController extends GetxController {
  final GetUserBookmark getUserBookmark;
  final DeleteUserBookmark deleteUserBookmark;
  final SubscribeUserBookmark subscribeUserBookmark;

  BookmarkController(this.getUserBookmark, this.deleteUserBookmark,
      this.subscribeUserBookmark);

  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    await _initialize();
    super.onInit();
  }

  Future<void> deleteBookmarkContent(UserBookmark bookmark) async {
    UserBookmarkEntity entity = bookmark.toCreateEntity();
    await deleteUserBookmark.execute(entity);
  }

  void onClickBookmark(UserBookmark bookmark) {
    Get.to(() => AppWebview(title: bookmark.title, uri: bookmark.url),
        transition: Transition.rightToLeftWithFade);
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _setupUserBookmark();
    _listenUserBookmark();
  }

  Future<void> _setupUserBookmark() async {
    final bookmarks = await getUserBookmark.execute();
    bookmarks.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      userBookmarks.assignAll(data);
    });
  }

  void _listenUserBookmark() {
    subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }
}
