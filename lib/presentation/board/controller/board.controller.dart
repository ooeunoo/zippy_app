import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/shuffle.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/domain/model/ad_content.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_articles.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/up_article_report_count.usecase.dart';
import 'package:zippy/domain/usecases/up_article_view_count.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/bottom_extension_menu.dart';

class BoardController extends GetxService {
  AdmobService admobService = Get.find<AdmobService>();

  final SubscribeArticles subscribeArticles;
  final SubscribeUserBookmark subscribeUserBookmark;
  final SubscribeUserSubscriptions subscribeUserSubscriptions;
  final GetPlatforms getPlatforms;
  final GetSources getSources;
  final GetArticles getArticles;
  final CreateUserBookmark createUserBookmark;
  final DeleteUserBookmark deleteUserBookmark;
  final GetUserBookmark getUserBookmark;
  final GetUserSubscriptions getUserSubscriptions;
  final UpArticleViewCount upArticleViewCount;
  final UpArticleReportCount upArticleReportCount;

  BoardController(
    this.subscribeArticles,
    this.subscribeUserBookmark,
    this.subscribeUserSubscriptions,
    this.getPlatforms,
    this.getSources,
    this.getArticles,
    this.createUserBookmark,
    this.deleteUserBookmark,
    this.getUserBookmark,
    this.getUserSubscriptions,
    this.upArticleViewCount,
    this.upArticleReportCount,
  );

  Rx<int> prevPageIndex = Rx<int>(0);
  PageController pageController = PageController(initialPage: 0);
  RxMap<int, Platform> platforms = RxMap<int, Platform>({}).obs();
  RxMap<int, Source> sources = RxMap<int, Source>({}).obs();
  RxBool isLoadingContents = RxBool(true).obs();
  RxBool isLoadingUserSubscription = RxBool(true).obs();
  RxList<Article> articles = RxList<Article>([]).obs();
  RxList<UserSubscription> userSubscriptions =
      RxList<UserSubscription>([]).obs();
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    await _initialize();
    super.onInit();
  }

  Platform? getPlatformBySourceId(int sourceId) {
    Source? source = sources[sourceId];

    if (source != null) {
      return platforms[source.platformId]!;
    } else {
      return null;
    }
  }

  Future<void> toggleBookmark(Article article) async {
    UserBookmarkEntity entity = UserBookmark(
      id: article.id!,
      title: article.title,
      link: article.link,
      content: article.content,
      images: article.images[0],
    ).toCreateEntity();
    onHeavyVibration();
    if (isBookmarked(article.id!)) {
      await deleteUserBookmark.execute(entity);
    } else {
      await createUserBookmark.execute(entity);
    }
  }

  Future<void> onOpenMenu(Article article) async {
    onHeavyVibration();
    Get.bottomSheet(BottomExtensionMenu(
        article: article,
        share: () async {
          await toShare(article.title, article.link);
        },
        report: () async {
          await onClickReport(article);
          notifyReported();
        }));
  }

  void jumpToArticle(int index) {
    pageController.jumpToPage(index);
  }

  Future<void> onClickReport(Article article) async {
    await upArticleReportCount.execute(article.id!);
  }

  bool isBookmarked(int itemId) {
    return userBookmarks.any((bookmark) => bookmark.id == itemId);
  }

  onChangedArticle(int curPageIndex) {
    if (curPageIndex < prevPageIndex.value) return;
    int credit = admobService.useAdContentCredits();
    NativeAd? nativeAd = admobService.nativeAd.value;

    if (credit == 0 && nativeAd != null) {
      AdContent adContent = AdContent(
        nativeAd: nativeAd,
      );
      articles.insert(curPageIndex + 1, adContent);
      articles.refresh();
      admobService.resetAdContent();
    }

    prevPageIndex.value = curPageIndex;
  }

  onClickItem(Article article) async {
    if (!article.isAd) {
      int credit = admobService.useIntersitialAdCredits();
      InterstitialAd? interstitialAd = admobService.interstitialAd.value;

      if (credit == 0 && interstitialAd != null) {
        admobService.interstitialAd.value!.show();
        admobService.resetIntersitialAdCredits();
      }

      Get.to(() => AppWebview(title: article.title, uri: article.link),
          transition: Transition.rightToLeftWithFade);

      await upArticleViewCount.execute(article.id!);
    }
  }

  refreshItem() {
    isLoadingContents.value = true;
    subscribeArticles
        .execute(userSubscriptions)
        .listen((List<Article> newArticles) {
      articles.bindStream(Stream.value(shuffle(newArticles)));
    });

    isLoadingContents.value = false;
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _setupPlatform();
    await _setupSources();
    await _setupUserSubscriptions();
    await _setupUserBookmark();

    _listenUserSubscriptions();
    _listenUserBookmark();

    await refreshItem();

    ever(userSubscriptions, (v) {
      refreshItem();
    });
  }

  Future<void> _setupPlatform() async {
    final result = await getPlatforms.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Channel!";
      }
    }, (data) {
      Map<int, Platform> map = {};
      for (var platform in data) {
        map = platform.toIdAssign(map);
      }
      platforms.assignAll(map);
    });
  }

  Future<void> _setupSources() async {
    final result = await getSources.execute();

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Subscription!";
      }
    }, (data) {
      Map<int, Source> map = {};
      for (var source in data) {
        map = source.toIdAssign(map);
      }
      sources.assignAll(map);
    });
  }

  Future<void> _setupUserSubscriptions() async {
    isLoadingUserSubscription.value = true;
    final subscriptions = await getUserSubscriptions.execute();
    subscriptions.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      userSubscriptions.assignAll(data);
    });
    isLoadingUserSubscription.value = false;
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

  void _listenUserSubscriptions() {
    subscribeUserSubscriptions.execute().listen((List<UserSubscription> event) {
      userSubscriptions.bindStream(Stream.value(event));
    });
  }

  void _listenUserBookmark() {
    subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }
}