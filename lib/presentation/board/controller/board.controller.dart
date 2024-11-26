import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/app/services/article.service.dart';

class BoardController extends GetxController {
  AuthService authService = Get.find<AuthService>();
  AdmobService admobService = Get.find<AdmobService>();
  ArticleService articleService = Get.find<ArticleService>();

  final currentPage = 0.obs;
  final prevPageIndex = 0.obs;

  final articles = RxList<Article>([]);
  final isLoadingContents = true.obs;
  final isLoadingUserSubscription = true.obs;
  final error = Rxn<String>();

  Future<void> onHandleFetchRecommendedArticles() async {
    try {
      isLoadingContents.value = true;

      final fetchedArticles =
          await articleService.onHandleFetchRecommendedArticles(
        GetRecommendedArticlesParams(
          userId: authService.currentUser.value?.id,
          excludeViewed: false,
          limit: 100,
        ),
      );

      if (fetchedArticles.isNotEmpty) {
        articles.assignAll(fetchedArticles);
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
    _initialize();
  }

  Future<void> _initialize() async {
    // 세션 초기화 상태 감지
    ever(authService.isInitializedSession, (bool initialized) {
      if (initialized) {
        onHandleFetchRecommendedArticles();
      }
    });
  }
}
