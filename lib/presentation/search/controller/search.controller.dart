import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/usecases/get_articles_by_keyword.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';

class AppSearchController extends GetxController {
  final AuthService authService = Get.find();
  final GetTrendingKeywords getTrendingKeywords = Get.find();
  final GetArticlesByKeyword getArticlesByKeyword = Get.find();

  RxList<Article> searchResults = RxList<Article>([]);
  RxList<KeywordRankSnapshot> trendingKeywords =
      RxList<KeywordRankSnapshot>([]);

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    await _fetchTrendingKeywords();
  }

  Future<void> _fetchTrendingKeywords() async {
    const params = GetTrandingKeywordsParams(contentType: null);
    final result = await getTrendingKeywords.execute(params);
    result.fold(
        (l) => null, (keywords) => trendingKeywords.assignAll(keywords));
  }

  /**
   * 키워드로 검색한 기사 조회
   */
  Future<List<Article>> onHandleFetchArticlesByKeyword(String keyword) async {
    final params = GetArticlesByKeywordParams(keyword: keyword);
    final result = await getArticlesByKeyword.execute(params);
    return result.fold((l) => [], (articles) {
      searchResults.assignAll(articles);
      return articles;
    });
  }
}
