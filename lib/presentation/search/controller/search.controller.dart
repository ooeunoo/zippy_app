import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/usecases/get_articles_by_keyword.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';

class AppSearchController extends SuperController {
  final AuthService authService = Get.find();
  final ArticleService articleService = Get.find();

  final GetTrendingKeywords getTrendingKeywords = Get.find();
  final GetArticlesByKeyword getArticlesByKeyword = Get.find();

  RxList<Article> searchArticles = RxList<Article>([]);
  RxList<KeywordRankSnapshot> trendingKeywords =
      RxList<KeywordRankSnapshot>([]);

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onResumed() {
    _initialize();
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  Future<void> _initialize() async {
    await _fetchTrendingKeywords();
  }

  Future<void> _fetchTrendingKeywords() async {
    const params = GetTrandingKeywordsParams(contentType: null);
    final result = await getTrendingKeywords.execute(params);
    result.fold(
        (l) => null, (keywords) => trendingKeywords.assignAll(keywords));
  }

  ///*********************************
  /// Public Methods
  ///*********************************
  Future<List<Article>> onHandleFetchArticlesBySearch(String keyword) async {
    final params = GetSearchArticlesParams(query: keyword);
    final result = await articleService.onHandleFetchSearchArticles(params);
    searchArticles.assignAll(result);
    return result;
  }

  Future<void> onHandleClickArticle(Article article) async {
    articleService.onHandleGoToArticleView(article);
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
    // TODO: implement onPaused
  }
}
