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
