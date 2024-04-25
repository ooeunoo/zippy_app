import 'dart:ui';

import 'package:get/get_rx/get_rx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_channel.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';

class BoardController extends GetxService {
  final admobService = Get.find<AdmobService>();
  final authController = Get.find<AuthController>();

  SupabaseProvider provider = Get.find();

  final SubscribeItems subscribeItems;
  final SubscribeUserChannel subscribeUserChannel;
  final SubscribeUserBookmark subscribeUserBookmark;

  final GetChannels getChannels;
  final GetCategories getCategories;
  final CreateBookmark createBookmark;
  final DeleteBookmark deleteBookmark;
  final GetBookmarksByUserId getBookmarksByUserId;
  final GetUserChannelByUserId getUserChannelByUserId;

  BoardController(
    this.subscribeItems,
    this.subscribeUserChannel,
    this.subscribeUserBookmark,
    this.getChannels,
    this.getCategories,
    this.createBookmark,
    this.deleteBookmark,
    this.getBookmarksByUserId,
    this.getUserChannelByUserId,
  );

  PageController pageController = PageController(initialPage: 0);
  RxList<Item> items = RxList<Item>([]).obs();
  RxList<UserChannel> userChannels = RxList<UserChannel>([]).obs();
  RxList<int> userBookmarkItemIds = RxList<int>([]).obs();
  RxMap<int, Channel> channels = RxMap<int, Channel>({}).obs();
  RxMap<int, Category> categories = RxMap<int, Category>({}).obs();
  RxBool isLoadingItems = RxBool(false).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    await _setupChannel();
    await _setupCategories();

    _listenUserChannel();
    _listenUserBookmark();

    super.onInit();
  }

  void refreshItem(List<UserChannel> channels) {
    isLoadingItems.value = true;
    Stream<List<Item>> result = subscribeItems.execute(channels);
    items.bindStream(result);
    isLoadingItems.value = false;
  }

  Channel? getChannelByCategoryId(int categoryId) {
    Category? category = categories[categoryId];
    if (category != null) {
      return channels[categories[categoryId]!.channelId]!;
    } else {
      return null;
    }
  }

  Future<void> toggleBookmark(int itemId) async {
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      BookmarkEntity entity =
          Bookmark(userId: user.id, itemId: itemId).toCreateEntity();
      onHeavyVibration();
      if (userBookmarkItemIds.contains(itemId)) {
        await deleteBookmark.execute(entity);
      } else {
        await createBookmark.execute(entity);
      }
    }
  }

  void onClickItem(Item item) {
    admobService.useCredit();

    if (admobService.interstitialAd.value != null) {
      admobService.interstitialAd.value!.show();
    }

    Get.to(() => AppWebview(uri: item.url),
        transition: Transition.rightToLeftWithFade);
  }

  _listenUserChannel() {
    isLoadingItems.value = true;
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      Stream<List<UserChannel>> result = subscribeUserChannel.execute(user.id);
      userChannels.bindStream(result);
      result.listen((channels) {
        refreshItem(channels);
      });
    }
  }

  _listenUserBookmark() {
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      Stream<List<Bookmark>> result = subscribeUserBookmark.execute(user.id);
      result.listen((bookmarks) {
        List<int> itemIds = [];
        for (var bookmark in bookmarks) {
          itemIds.add(bookmark.itemId);
        }
        userBookmarkItemIds.assignAll(itemIds);
      });
    }
  }

  _setupChannel() async {
    final result = await getChannels.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Channel!";
      }
    }, (data) {
      Map<int, Channel> map = {};
      for (var channel in data) {
        map = channel.toIdAssign(map);
      }
      channels.assignAll(map);
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
}
