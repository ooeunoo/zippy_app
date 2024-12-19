import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_random_articles.params.dart';
import 'package:zippy/app/services/article.service.dart';

class BoardController extends SuperController {
  AuthService authService = Get.find<AuthService>();
  AdmobService admobService = Get.find<AdmobService>();
  ArticleService articleService = Get.find<ArticleService>();

  final currentPage = 0.obs;
  final prevPageIndex = 0.obs;

  final articles = RxList<Article>([]);
  final isLoadingContents = true.obs;
  final isLoadingUserSubscription = true.obs;
  final error = Rxn<String>();

  Future<void> onHandleFetchRandomArticles() async {
    try {
      isLoadingContents.value = true;

      final fetchedArticles = await articleService.onHandleFetchRandomArticles(
        GetRandomArticlesParams(
          userId: authService.currentUser.value?.id,
          limit: 100,
        ),
      );
      print('fetchedArticles: ${fetchedArticles}');

      if (fetchedArticles.isNotEmpty) {
        articles.clear();
        articles.addAll(fetchedArticles);

        // 이미지 미리 캐시
        for (var article in fetchedArticles) {
          if (article.images.isNotEmpty) {
            precacheImage(
                CachedNetworkImageProvider(article.images[0]), Get.context!);
          }
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingContents.value = false;
    }
  }

  Future<void> onHandleChangedArticle(int curPageIndex) async {
    if (curPageIndex < prevPageIndex.value) return;
    int credit = admobService.useCardAdCredits();
    NativeAd? nativeAd = admobService.cardAd.value;

    if (credit == 0 && nativeAd != null) {
      AdArticle adArticle = AdArticle(nativeAd: nativeAd);
      articles.insert(curPageIndex + 1, adArticle);
      articles.refresh();
      admobService.resetCardAdContent();
    }

    prevPageIndex.value = curPageIndex;
  }

  Future<void> onHandleClickArticle(Article article) async {
    if (article.isAd) return;
    articleService.onHandleGoToArticleView(article);
  }

  Future<void> onHandleClickBookmark() async {
    if (authService.isLoggedIn.value) {
      Get.toNamed(Routes.bookmark);
    } else {
      showLoginDialog();
    }
  }

  @override
  void onInit() {
    super.onInit();
    onHandleFetchRandomArticles();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    print('onPaused');
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
