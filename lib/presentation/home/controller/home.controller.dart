import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/domain/enum/article_category_type.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_search_articles.params.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';
import 'package:zippy/domain/usecases/get_article_with_category.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';
import 'package:zippy/presentation/home/page/views/search.dart';

class HomeController extends GetxController {
  final ArticleService articleService = Get.find();
  final ContentTypeService contentTypeService = Get.find();
  final GetTrendingKeywords getTrendingKeywords = Get.find();
  final GetArticleWithCategory getArticleWithCategory = Get.find();

  final contentTypes = RxList<ContentType>([]);
  final topArticlesByContentType = RxList<TopArticlesByContentType>([]);
  final trendingKeywords = RxList<KeywordRankSnapshot>([]);

  final selectedCategory = ArticleCategoryType.TOP.obs;
  final selectedContentType = Rxn<ContentType>(null);
  final articleWithCategory =
      RxMap<ContentType, Map<ArticleCategoryType, List<Article>>>({});

  final int pageSize = 10;
  RxInt currentPage = 1.obs;
  RxBool isSearchLoading = false.obs;
  RxBool hasMoreSearchData = true.obs;
  RxList<Article> searchArticles = RxList<Article>([]);
  RxString currentQuery = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(contentTypeService.contentTypes, (value) {
      contentTypes.value = value;
      if (contentTypes.isNotEmpty) {
        selectedContentType.value = contentTypes.first;
        onHandleFetchArticleWithCategory(contentTypes.first);
      }
    });
    ever(selectedContentType, (value) {
      if (value != null) {
        if (articleWithCategory[value] == null) {
          isLoading.value = true;
          onHandleFetchArticleWithCategory(value);
          isLoading.value = false;
        }
      }
    });
    onHandleFetchTrendingKeywords();
  }

  Future<void> onHandleFetchArticleWithCategory(ContentType contentType) async {
    final result = await getArticleWithCategory.execute(contentType.id);
    result.fold((failure) {}, (articles) {
      articleWithCategory[contentType] = articles.result;
    });
  }

  Future<void> onHandleFetchTrendingKeywords() async {
    final result =
        await getTrendingKeywords.execute(const GetTrandingKeywordsParams(
      contentType: null,
    ));
    result.fold((failure) {}, (keywords) {
      trendingKeywords.clear();
      trendingKeywords.addAll(keywords);
    });
  }

  Future<List<Article>> onHandleFetchArticlesBySearch(String keyword,
      {bool refresh = false}) async {
    // If refresh is true or it's a new search, reset pagination
    if (refresh || currentQuery.value != keyword) {
      currentPage.value = 1;
      hasMoreSearchData.value = true;
      searchArticles.clear();
      currentQuery.value = keyword;
    }

    // If we're already loading or there's no more data, return
    if (isSearchLoading.value || !hasMoreSearchData.value) {
      isSearchLoading.value = false;
      return searchArticles;
    }

    isSearchLoading.value = true;

    try {
      final params = GetSearchArticlesParams(
        query: keyword,
        page: currentPage.value,
        size: pageSize,
      );

      final result = await articleService.onHandleFetchSearchArticles(params);
      if (result.length < pageSize) {
        hasMoreSearchData.value = false;
      }

      if (currentPage.value == 1) {
        searchArticles.clear();
      }

      searchArticles.addAll(result);
      currentPage.value++;

      return result;
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> refreshSearch() async {
    if (currentQuery.value.isNotEmpty) {
      await onHandleFetchArticlesBySearch(currentQuery.value, refresh: true);
    }
  }

  onHandleGoToSearchView(String? search) {
    Get.to(() => SearchView(keyword: search));
  }
}
