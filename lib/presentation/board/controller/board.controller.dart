import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/ad_content.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/presentation/board/page/widgets/bottom_extension_menu.dart';
import 'package:zippy/app/services/article.service.dart';

class BoardController extends GetxService {
  AuthService authService = Get.find<AuthService>();
  AdmobService admobService = Get.find<AdmobService>();
  ArticleService articleService = Get.find<ArticleService>();

  Rx<int> prevPageIndex = Rx<int>(0);
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0, // 전체 화면 표시
    keepPage: true, // 페이지 상태 유지
  );

  final articles = RxList<Article>([]);
  final isLoadingContents = true.obs;
  final isLoadingUserSubscription = true.obs;
  final error = Rxn<String>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> onHandleFetchRecommendedArticles() async {
    try {
      isLoadingContents.value = true;
      final fetchedArticles =
          await articleService.onHandleFetchRecommendedArticles(
        GetRecommendedArticlesParams(
          userId: authService.currentUser.value?.id,
        ),
      );

      articles.assignAll(fetchedArticles);
    } finally {
      isLoadingContents.value = false;
    }
  }

  Future<void> onHandleOpenMenu(Article article) async {
    onHeavyVibration();
    Get.bottomSheet(BottomExtensionMenu(
      article: article,
      share: () => _handleUserAction(
        requiredLoggedIn: false,
        action: () async {
          await toShare(article.title, article.link);
          await articleService.onHandleCreateUserInteraction(
            article.id!,
            InteractionType.Share,
          );
        },
      ),
      report: () => _handleUserAction(
        requiredLoggedIn: true,
        action: () async {
          await articleService.onHandleCreateUserInteraction(
            article.id!,
            InteractionType.Report,
          );
          notifyReported();
        },
      ),
    ));
  }

  Future<void> onHandleJumpToArticle(int index) async {
    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300), // 애니메이션 시간
      curve: Curves.easeInOut, // 부드러운 애니메이션 커브
    );
  }

  Future<void> onHandleChangedArticle(int curPageIndex) async {
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

  Future<void> onHandleClickArticle(Article article) async {
    if (article.isAd) return;
    await _handleInterstitialAd();
    articleService.showArticleViewModal(article);
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

  //////////////////////////////////////////////////////////////////
  /// Initialization Methods
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await onHandleFetchRecommendedArticles();
  }
}
