import 'dart:async';

import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark_folder.usecase.dart';

class BookmarkService extends GetxService {
  final AuthService authService = Get.find<AuthService>();

  final CreateUserBookmark createUserBookmark = Get.find();
  final DeleteUserBookmark deleteUserBookmark = Get.find();
  final GetUserBookmark getUserBookmark = Get.find();
  final SubscribeUserBookmark subscribeUserBookmark = Get.find();

  final CreateUserBookmarkFolder createUserBookmarkFolder = Get.find();
  final GetUserBookmarkFolders getUserBookmarkFolders = Get.find();
  final DeleteUserBookmarkFolder deleteUserBookmarkFolder = Get.find();
  final SubscribeUserBookmarkFolder subscribeUserBookmarkFolder = Get.find();

  RxList<UserBookmarkFolder> userBookmarkFolders =
      RxList<UserBookmarkFolder>([]);
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();

  StreamSubscription? _userBookmarksSubscription;
  StreamSubscription? _userBookmarkFoldersSubscription;
  StreamSubscription? _authUserSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onClose() {
    _authUserSubscription?.cancel();
    _cancelBookmarkSubscriptions();
    _cancelUserBookmarkFoldersSubscription();
    super.onClose();
  }

  ///*********************************
  /// Getter Methods
  ///*********************************
  bool isBookmarked(int itemId) {
    return userBookmarks.any((bookmark) => bookmark.id == itemId);
  }

  ///*********************************
  /// Handle Methods
  ///*********************************
  Future<void> onHandleCreateUserBookmarkFolder(
      UserBookmarkFolder folder) async {
    await createUserBookmarkFolder.execute(folder.toCreateEntity());
  }

  Future<void> onHandleDeleteUserBookmarkFolder(String folderId) async {
    await deleteUserBookmarkFolder.execute(folderId);
  }

  Future<void> onHandleDeleteUserBookmark(int bookmarkId) async {
    await deleteUserBookmark.execute(bookmarkId);
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  Future<void> _initialize() async {
    await _setupUserBookmark();
    await _setupUserBookmarkFolders();
    _listenUser();
  }

  ///*********************************
  /// Private Methods
  ///*********************************
  Future<void> _setupUserBookmark() async {
    final bookmarks = await getUserBookmark.execute();
    bookmarks.fold((failure) {
      userBookmarks.value = [];
    }, (data) {
      userBookmarks.assignAll(data);
    });
  }

  Future<void> _setupUserBookmarkFolders() async {
    final result = await getUserBookmarkFolders.execute();
    result.fold((failure) {
      userBookmarkFolders.value = [];
    }, (data) {
      userBookmarkFolders.assignAll(data);
    });
  }

  ///*********************************
  /// Listen Subscriptions
  ///*********************************
  void _listenUser() {
    _authUserSubscription = authService.currentUser.listen((user) {
      _cancelBookmarkSubscriptions();
      _cancelUserBookmarkFoldersSubscription();
      if (user != null) {
        _setupBookmarkSubscriptions();
        _setupUserBookmarkFoldersSubscription();
      }
    });
  }

  void _setupBookmarkSubscriptions() {
    _userBookmarksSubscription =
        subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }

  void _setupUserBookmarkFoldersSubscription() {
    _userBookmarkFoldersSubscription = subscribeUserBookmarkFolder
        .execute()
        .listen((List<UserBookmarkFolder> event) {
      userBookmarkFolders.bindStream(Stream.value(event));
    });
  }

  void _cancelBookmarkSubscriptions() {
    _userBookmarksSubscription?.cancel();
    _userBookmarksSubscription = null;
  }

  void _cancelUserBookmarkFoldersSubscription() {
    _userBookmarkFoldersSubscription?.cancel();
    _userBookmarkFoldersSubscription = null;
  }
}
