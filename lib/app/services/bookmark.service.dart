import 'dart:async';

import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/params/create_bookmark_folder.params.dart';
import 'package:zippy/domain/model/params/create_bookmark_item.params.dart';
import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmarks.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark_folder.usecase.dart';

class BookmarkService extends GetxService {
  final AuthService authService = Get.find<AuthService>();

  final CreateUserBookmark createUserBookmark = Get.find();
  final DeleteUserBookmark deleteUserBookmark = Get.find();
  final GetUserBookmarks getUserBookmarks = Get.find();
  final SubscribeUserBookmark subscribeUserBookmark = Get.find();

  final CreateUserBookmarkFolder createUserBookmarkFolder = Get.find();
  final GetUserBookmarkFolders getUserBookmarkFolders = Get.find();
  final DeleteUserBookmarkFolder deleteUserBookmarkFolder = Get.find();
  final SubscribeUserBookmarkFolder subscribeUserBookmarkFolder = Get.find();

  RxList<UserBookmarkFolder> userBookmarkFolders =
      RxList<UserBookmarkFolder>([]);
  RxList<UserBookmarkItem> userBookmarks = RxList<UserBookmarkItem>([]);
  RxMap<int, UserBookmarkItem> userBookmarkFolderItemMap =
      RxMap<int, UserBookmarkItem>({});

  StreamSubscription? _authUserSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onClose() {
    _authUserSubscription?.cancel();
    super.onClose();
  }

  ///*********************************
  /// Getter Methods
  ///*********************************
  UserBookmarkItem? isBookmarked(int itemId) {
    final bookmark = userBookmarks.firstWhereOrNull(
      (bookmark) => bookmark.article!.id == itemId,
    );

    return bookmark;
  }

  ///*********************************
  /// Handle Methods
  ///*********************************
  Future<void> onHandleCreateUserBookmarkFolder(
      String name, String? description) async {
    await createUserBookmarkFolder.execute(CreateBookmarkFolderParams(
      userId: authService.currentUser.value!.id,
      name: name,
      description: description,
    ));
    await _fetchUserBookmarkFolders();
  }

  Future<void> onHandleDeleteUserBookmarkFolder(int folderId) async {
    await deleteUserBookmarkFolder.execute(folderId);
    await _fetchUserBookmarkFolders();
  }

  Future<void> onHandleCreateUserBookmark(
      CreateBookmarkItemParams params) async {
    await createUserBookmark.execute(params);
    await _fetchUserBookmark();
  }

  Future<void> onHandleDeleteUserBookmark(int bookmarkId) async {
    await deleteUserBookmark.execute(bookmarkId);
    await _fetchUserBookmark();
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  Future<void> _initialize() async {
    _listenUser();
    await _fetchUserBookmarkFolders();
    await _fetchUserBookmark();
  }

  ///*********************************
  /// Private Methods
  ///*********************************
  Future<void> _fetchUserBookmarkFolders() async {
    if (authService.isLoggedIn.value == false) {
      return;
    }

    final userId = authService.currentUser.value!.id;

    final result = await getUserBookmarkFolders.execute(userId);
    result.fold((failure) {
      userBookmarkFolders.value = [];
    }, (data) {
      userBookmarkFolders.assignAll(data);
    });
  }

  Future<void> _fetchUserBookmark() async {
    if (authService.isLoggedIn.value == false) {
      return;
    }

    final userId = authService.currentUser.value!.id;

    final bookmarks = await getUserBookmarks.execute(userId);
    bookmarks.fold((failure) {
      userBookmarks.value = [];
    }, (data) {
      userBookmarks.assignAll(data);
    });
  }

  ///*********************************
  /// Listen Subscriptions
  ///*********************************
  void _listenUser() {
    _authUserSubscription?.cancel();
    _authUserSubscription = authService.currentUser.listen((user) {
      if (user != null) {
        _fetchUserBookmarkFolders();
        _fetchUserBookmark();
      }
    });
  }
}
