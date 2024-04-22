import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/community.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_communities.dart';
import 'package:zippy/domain/usecases/get_user_community_by_user_id.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';

class BoardController extends GetxController {
  final authController = Get.find<AuthController>();
  
  final SubscribeItems subscribeItems;
  final GetCommunites getCommunites;
  final GetCategories getCategories;
  final CreateBookmark createBookmark;
  final DeleteBookmark deleteBookmark;
  final GetBookmarksByUserId getBookmarksByUserId;
  final GetUserCommunityByUserId getUserCommunityByUserId;

  BoardController(
    this.subscribeItems,
    this.getCommunites,
    this.getCategories,
    this.createBookmark,
    this.deleteBookmark,
    this.getBookmarksByUserId,
    this.getUserCommunityByUserId,
  );

  PageController pageController = PageController(initialPage: 0);
  RxList<Item> subscribers = RxList<Item>([]).obs();
  RxMap<int, Community> communities = RxMap<int, Community>({}).obs();
  RxMap<int, Category> categories = RxMap<int, Category>({}).obs();
  RxMap<int, int> bookmarkItemMap = RxMap<int, int>({}).obs();
  RxList<int> bookmarkItemIds = RxList<int>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();

    subscribers.bindStream(subscribe());

    await _setupCommunity();
    await _setupCategories();
    await _setupBookmarks();

    ever(error, (e) => print(e));
  }

  Stream<List<Item>> subscribe() {
    Stream<List<Item>> result = subscribeItems.execute();
    return result;
  }

  Community? getCommunityByCategoryId(int categoryId) {
    Category? category = categories[categoryId];
    if (category != null) {
      return communities[categories[categoryId]!.communityId]!;
    } else {
      return null;
    }
  }

  Future<void> toggleBookmark(int itemId) async {
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      BookmarkEntity entity =
          Bookmark(userId: user.id, itemId: itemId).toCreateEntity();

      if (bookmarkItemIds.contains(itemId)) {
        await deleteBookmark.execute(entity);
        bookmarkItemIds.remove(itemId);
      } else {
        await createBookmark.execute(entity);
        bookmarkItemIds.add(itemId);
      }
    }
  }

  _setupCommunity() async {
    final result = await getCommunites.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Community!";
      }
    }, (data) {
      Map<int, Community> map = {};
      for (var community in data) {
        map = community.toIdAssign(map);
      }
      communities.assignAll(map);
    });
  }

  _setupCategories() async {
    final result = await getCategories.execute();

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Category!";
      }
    }, (data) {
      Map<int, Category> map = {};
      for (var category in data) {
        map = category.toIdAssign(map);
      }
      categories.assignAll(map);
    });
  }

  _setupBookmarks() async {
    UserModel? user = authController.user.value;
    if (user != null) {
      final result = await getBookmarksByUserId.execute(user.id);
      result.fold((failure) {
        if (failure == ServerFailure()) {
          error.value = 'Error Fetching Bookmark!';
        }
      }, (data) {
        List<int> list = [];
        Map<int, int> map = {};
        for (var bookmark in data) {
          list.add(bookmark.itemId);
          map[bookmark.itemId] = bookmark.id!;
        }
        bookmarkItemIds.assignAll(list);
        bookmarkItemMap.assignAll(map);
        print('bookmarkItemMap: $bookmarkItemMap');
      });
    }
  }
}
