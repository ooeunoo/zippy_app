import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/domain/model/ad_content.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/domain/model/user_bookmark.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.dart';
import 'package:zippy/domain/usecases/get_user_category.dart';
import 'package:zippy/domain/usecases/subscirbe_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_category%20.dart';

class BoardController extends GetxService {
  final admobService = Get.find<AdmobService>();
  // final authController = Get.find<AuthController>();

  SupabaseProvider provider = Get.find();

  final SubscribeContents subscribeContents;
  final SubscribeUserBookmark subscribeUserBookmark;
  final SubscribeUserCategory subscribeUserCategory;
  final GetChannels getChannels;
  final GetCategories getCategories;
  final CreateUserBookmark createUserBookmark;
  final DeleteUserBookmark deleteUserBookmark;
  final GetUserBookmark getUserBookmark;
  final GetUserCategory getUserCategory;

  BoardController(
    this.subscribeContents,
    this.subscribeUserBookmark,
    this.subscribeUserCategory,
    this.getChannels,
    this.getCategories,
    this.createUserBookmark,
    this.deleteUserBookmark,
    this.getUserBookmark,
    this.getUserCategory,
  );

  Rx<int> prevPageIndex = Rx<int>(0);
  PageController pageController = PageController(initialPage: 0);
  RxMap<int, Channel> channels = RxMap<int, Channel>({}).obs();
  RxMap<int, Category> categories = RxMap<int, Category>({}).obs();
  RxBool isLoadingItems = RxBool(true).obs();
  RxBool isLoadingUserCategory = RxBool(true).obs();
  RxList<Content> contents = RxList<Content>([]).obs();
  RxList<UserCategory> userCategories = RxList<UserCategory>([]).obs();
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    await _initialize();
    super.onInit();
  }

  Channel? getChannelByCategoryId(int categoryId) {
    Category? category = categories[categoryId];
    if (category != null) {
      return channels[categories[categoryId]!.channelId]!;
    } else {
      return null;
    }
  }

  Future<void> toggleBookmark(Content content) async {
    UserBookmarkEntity entity = UserBookmark(
      id: content.id!,
      title: content.title,
      url: content.url,
      contentText: content.contentText,
      contentImgUrl: content.contentImgUrl,
    ).toCreateEntity();
    onHeavyVibration();
    if (isBookmarked(content.id!)) {
      await deleteUserBookmark.execute(entity);
    } else {
      await createUserBookmark.execute(entity);
    }
  }

  bool isBookmarked(int itemId) {
    return userBookmarks.any((bookmark) => bookmark.id == itemId);
  }

  onChangedItem(int curPageIndex) {
    if (curPageIndex < prevPageIndex.value) return;
    int credit = admobService.useAdContentCredits();
    NativeAd? nativeAd = admobService.nativeAd.value;

    if (credit == 0 && nativeAd != null) {
      AdContent adContent = AdContent(
        nativeAd: nativeAd,
      );
      contents.insert(curPageIndex + 1, adContent);
      contents.refresh();
      admobService.resetAdContent();
    }

    prevPageIndex.value = curPageIndex;
  }

  onClickItem(Content content) {
    if (!content.isAd) {
      int credit = admobService.useIntersitialAdCredits();
      InterstitialAd? interstitialAd = admobService.interstitialAd.value;

      if (credit == 0 && interstitialAd != null) {
        admobService.interstitialAd.value!.show();
        admobService.resetIntersitialAdCredits();
      }

      Get.to(() => AppWebview(title: content.title, uri: content.url),
          transition: Transition.rightToLeftWithFade);
    }
  }

  refreshItem() {
    isLoadingItems.value = true;
    subscribeContents
        .execute(userCategories)
        .listen((List<Content> newContents) {
      contents.bindStream(Stream.value(newContents));
    });

    isLoadingItems.value = false;
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _setupChannel();
    await _setupCategories();
    await _setupUserCategory();
    await _setupUserBookmark();

    _listenUserCategories();
    _listenUserBookmark();

    await refreshItem();

    ever(userCategories, (v) {
      refreshItem();
    });
  }

  Future<void> _setupChannel() async {
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

  Future<void> _setupCategories() async {
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

  Future<void> _setupUserCategory() async {
    isLoadingUserCategory.value = true;
    final categories = await getUserCategory.execute();
    categories.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      userCategories.assignAll(data);
    });
    isLoadingUserCategory.value = false;
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

  void _listenUserCategories() {
    subscribeUserCategory.execute().listen((List<UserCategory> event) {
      userCategories.bindStream(Stream.value(event));
    });
  }

  void _listenUserBookmark() {
    subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }
}
