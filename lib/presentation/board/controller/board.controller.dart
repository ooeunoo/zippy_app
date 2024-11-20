import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
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
      AdArticle adArticle = AdArticle(
        nativeAd: nativeAd,
      );
      articles.insert(curPageIndex + 1, adArticle);
      articles.refresh();
      admobService.resetAdContent();
    }

    prevPageIndex.value = curPageIndex;
  }

  Future<void> onHandleClickArticle(Article article) async {
    if (article.isAd) return;
    await _handleInterstitialAd();
    articleService.onHandleGoToArticleView(article);
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

  //////////////////////////////////////////////////////////////////
  /// Initialization Methods
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await onHandleFetchRecommendedArticles();
  }
}
