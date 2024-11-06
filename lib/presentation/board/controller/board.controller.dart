import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/shuffle.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/domain/enum/article_view_type.enum.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/ad_content.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_articles.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/bottom_extension_menu.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_view.dart';

class BoardController extends GetxService {
  AuthService authService = Get.find<AuthService>();
  AdmobService admobService = Get.find<AdmobService>();

  final SubscribeArticles subscribeArticles = Get.find();
  final SubscribeUserBookmark subscribeUserBookmark = Get.find();
  final SubscribeUserSubscriptions subscribeUserSubscriptions = Get.find();
  final GetPlatforms getPlatforms = Get.find();
  final GetSources getSources = Get.find();
  final GetArticles getArticles = Get.find();
  final CreateUserBookmark createUserBookmark = Get.find();
  final DeleteUserBookmark deleteUserBookmark = Get.find();
  final GetUserBookmark getUserBookmark = Get.find();
  final GetUserSubscriptions getUserSubscriptions = Get.find();
  final CreateUserInteraction createUserInteraction = Get.find();
  final UpdateUserInteraction updateUserInteraction = Get.find();

  Rx<int> prevPageIndex = Rx<int>(0);
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0, // 전체 화면 표시
    keepPage: true, // 페이지 상태 유지
  );

  RxMap<int, Platform> platforms = RxMap<int, Platform>({}).obs();
  RxMap<int, Source> sources = RxMap<int, Source>({}).obs();
  RxBool isLoadingContents = RxBool(true).obs();
  RxBool isLoadingUserSubscription = RxBool(true).obs();
  RxList<Article> articles = RxList<Article>([]).obs();
  RxList<UserSubscription> userSubscriptions =
      RxList<UserSubscription>([]).obs();
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();
  Rxn<String> error = Rxn<String>();
  Rx<ArticleViewType> currentViewType = ArticleViewType.Keypoint.obs;

  @override
  onInit() async {
    await _initialize();
    super.onInit();
  }

  Source? getSourceById(int sourceId) {
    Source? source = sources[sourceId];

    if (source != null) {
      return source;
    } else {
      return null;
    }
  }

  Future<void> bookmarkArticle(Article article) async {
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

  Future<void> shareArticle(Article article) async {
    await toShare(article.title, article.link);
    await _createInteraction(article.id!, InteractionType.Share);
  }

  Future<void> commentArticle(Article article) async {}

  Future<void> reportArticle(Article article) async {}

  Future<void> onOpenMenu(Article article) async {
    onHeavyVibration();
    Get.bottomSheet(BottomExtensionMenu(
      article: article,
      share: () => _handleUserAction(
        requiredLoggedIn: false,
        action: () async {
          await toShare(article.title, article.link);
          await _createInteraction(
            article.id!,
            InteractionType.Share,
          );
        },
      ),
      report: () => _handleUserAction(
        requiredLoggedIn: true,
        action: () async {
          await _createInteraction(
            article.id!,
            InteractionType.Report,
          );
          notifyReported();
        },
      ),
    ));
  }

  void jumpToArticle(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300), // 애니메이션 시간
      curve: Curves.easeInOut, // 부드러운 애니메이션 커브
    );
  }

  bool isBookmarked(int itemId) {
    return userBookmarks.any((bookmark) => bookmark.id == itemId);
  }

  void changeViewType(ArticleViewType type) {
    currentViewType.value = type;
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

  Future<void> onClickArticle(Article article) async {
    if (article.isAd) return;

    await _handleInterstitialAd();

    final handleUpdateInteraction = await _createViewInteraction(article.id!);

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      elevation: 0,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.95],
        builder: (context, scrollController) {
          return ClipRRect(
            // 추가
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(
                  () => ZippyArticleView(
                    scrollController: scrollController,
                    article: article,
                    handleUpdateUserInteraction: handleUpdateInteraction,
                    viewType: currentViewType.value, // 현재 뷰 타입 전달
                    onViewTypeChanged: changeViewType, // 상태 변경 콜백 전달
                  ),
                )),
          );
        },
      ),
    );
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
  /// PRIVATE METHODS
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _handleInterstitialAd() async {
    final credit = admobService.useIntersitialAdCredits();
    final interstitialAd = admobService.interstitialAd.value;

    if (credit == 0 && interstitialAd != null) {
      interstitialAd.show();
      admobService.resetIntersitialAdCredits();
    }
  }

  Future<Function(int, int)?> _createViewInteraction(int articleId) async {
    if (!authService.isLoggedIn.value) return null;

    final result = await createUserInteraction.execute(
      CreateUserInteractionParams(
        userId: authService.currentUser.value!.id,
        articleId: articleId,
        interactionType: InteractionType.View,
      ),
    );

    return result.fold(
      (failure) => null,
      (interaction) => (int readPercent, int readDuration) async {
        await _handleUpdateUserInteraction(
          interaction.id!,
          readPercent,
          readDuration,
        );
      },
    );
  }

  Future<void> _handleUserAction({
    required bool requiredLoggedIn,
    required Future<void> Function() action,
  }) async {
    bool isLoggedIn = authService.isLoggedIn.value;
    // requiredLoggedIn가 true이고 로그인이 되어있지 않으면 로그인 다이얼로그 표시
    if (!requiredLoggedIn && !isLoggedIn) {
      Get.back(); // bottomSheet 닫기
      // 약간의 딜레이를 주어 bottomSheet가 완전히 닫힌 후 다이얼로그 표시
      Future.delayed(const Duration(milliseconds: 100), () {
        showLoginDialog();
      });
      return;
    }
    await action();
  }

  Future<void> _createInteraction(int articleId, InteractionType type) async {
    await createUserInteraction.execute(CreateUserInteractionParams(
      userId: authService.currentUser.value!.id,
      articleId: articleId,
      interactionType: type,
    ));
  }

  Future<void> _handleUpdateUserInteraction(
      int id, int readPercent, int readDuration) async {
    await updateUserInteraction.execute(UpdateUserInteractionParams(
      id: id,
      readPercent: readPercent,
      readDuration: readDuration,
    ));
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

    _listenUserBookmark();
    // _listenUserSubscriptions();
    // _listenUser();

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
    final result = await getSources.execute(withJoin: true);

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
      // print(sources);
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

  // void _listenUserSubscriptions() {
  //   if (user != null) {
  //     subscribeUserSubscriptions
  //         .execute(user!.id)
  //         .listen((List<UserSubscription> event) {
  //       userSubscriptions.bindStream(Stream.value(event));
  //     });
  //   }
  // }

  void _listenUserBookmark() {
    subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }

  // void _listenUser() {
  //   authService.currentUser.listen((user) {
  //     if (user != null) {
  //       this.user = user;
  //       _listenUserSubscriptions();
  //     }
  //   });
  // }
}
