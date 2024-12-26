import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_search_articles.params.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/usecases/get_articles_by_keyword.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';

class AppSearchController extends SuperController {
  final AuthService authService = Get.find();
  final ArticleService articleService = Get.find();
  final ContentTypeService contentTypeService = Get.find();

  final GetTrendingKeywords getTrendingKeywords = Get.find();
  final GetArticlesByKeyword getArticlesByKeyword = Get.find();

  RxList<ContentType> tabs = RxList<ContentType>([]);
  RxMap<int, RxList<KeywordRankSnapshot>> trendingKeywords =
      RxMap<int, RxList<KeywordRankSnapshot>>({});

  final int pageSize = 10;
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool hasMoreData = true.obs;
  RxList<Article> searchArticles = RxList<Article>([]);
  RxString currentQuery = ''.obs;

  DateTime? _pausedTime;

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onResumed() {
    if (_pausedTime != null) {
      final difference = DateTime.now().difference(_pausedTime!);
      if (difference.inMinutes >= 10) {
        _initialize();
      }
    }
    _pausedTime = null;
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  Future<void> _initialize() async {
    tabs.addAll(
        contentTypeService.contentTypes.where((type) => type.showRank == true));
    await fetchTrendingKeywords(null);
    for (var tab in tabs) {
      await fetchTrendingKeywords(tab);
    }
  }

  Future<void> fetchTrendingKeywords(ContentType? contentType) async {
    final params = GetTrandingKeywordsParams(contentType: contentType);
    final result = await getTrendingKeywords.execute(params);
    result.fold(
        (l) => null,
        (keywords) =>
            trendingKeywords[contentType?.id ?? 0] = RxList.from(keywords));
  }

  ///*********************************
  /// Public Methods
  ///*********************************
  Future<List<Article>> onHandleFetchArticlesBySearch(String keyword,
      {bool refresh = false}) async {
    // If refresh is true or it's a new search, reset pagination
    if (refresh || currentQuery.value != keyword) {
      currentPage.value = 1;
      hasMoreData.value = true;
      searchArticles.clear();
      currentQuery.value = keyword;
    }

    // If we're already loading or there's no more data, return
    if (isLoading.value || !hasMoreData.value) return searchArticles;

    isLoading.value = true;

    try {
      final params = GetSearchArticlesParams(
        query: keyword,
        page: currentPage.value,
        size: pageSize,
      );

      final result = await articleService.onHandleFetchSearchArticles(params);
      if (result.length < pageSize) {
        hasMoreData.value = false;
      }

      if (currentPage.value == 1) {
        searchArticles.clear();
      }

      searchArticles.addAll(result);
      currentPage.value++;

      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSearch() async {
    if (currentQuery.value.isNotEmpty) {
      await onHandleFetchArticlesBySearch(currentQuery.value, refresh: true);
    }
  }

  Future<void> onHandleClickArticle(Article article) async {
    articleService.onHandleGoToArticleView(article);
  }

  @override
  void onDetached() {
    print('onDetached');
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    print('onHidden');
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    print('onInactive');
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    _pausedTime = DateTime.now();
    print('onPaused');
  }
}
