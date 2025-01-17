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
import 'package:zippy/presentation/home/page/views/keyword_articles.view.dart';
import 'package:zippy/presentation/home/page/views/search.view.dart';

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

  // Search related
  final int pageSize = 10;
  RxInt currentPage = 1.obs;
  RxBool isSearchLoading = false.obs;
  RxBool hasMoreSearchData = true.obs;
  RxList<Article> searchArticles = RxList<Article>([]);
  RxString currentQuery = ''.obs;
  RxBool isInitLoading = false.obs; // 초기 로딩 상태 추가

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeContentTypeListener();
    _initializeSelectedContentTypeListener();
    onHandleFetchTrendingKeywords();
  }

  void _initializeContentTypeListener() {
    ever(contentTypeService.contentTypes, (List<ContentType> value) {
      contentTypes.value = value;
      if (contentTypes.isNotEmpty) {
        selectedContentType.value = contentTypes.first;
        _loadArticlesForContentType(contentTypes.first);
      }
    });
  }

  void _initializeSelectedContentTypeListener() {
    ever(selectedContentType, (ContentType? value) {
      if (value != null) {
        _loadArticlesForContentType(value);
      }
    });

    // 카테고리 변경 리스너 추가
    ever(selectedCategory, (ArticleCategoryType category) {
      if (selectedContentType.value != null) {
        // 현재 컨텐츠 타입에 대한 데이터가 없으면 로드
        if (!articleWithCategory.containsKey(selectedContentType.value)) {
          _loadArticlesForContentType(selectedContentType.value!);
        }
      }
    });
  }

  Future<void> _loadArticlesForContentType(ContentType contentType) async {
    if (articleWithCategory.containsKey(contentType) &&
        articleWithCategory[contentType]?[selectedCategory.value] != null) {
      return; // 이미 현재 카테고리의 데이터가 있으면 스킵
    }

    isLoading.value = true;
    try {
      await onHandleFetchArticleWithCategory(contentType);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onHandleFetchArticleWithCategory(ContentType contentType) async {
    final result = await getArticleWithCategory.execute(contentType.id);
    result.fold(
      (failure) {
        // 에러 처리를 추가할 수 있습니다.
      },
      (articles) {
        articleWithCategory[contentType] = articles.result;
      },
    );
  }

  Future<void> onHandleFetchTrendingKeywords() async {
    final result = await getTrendingKeywords.execute(
      const GetTrandingKeywordsParams(contentType: null),
    );

    result.fold(
      (failure) {
        // 에러 처리를 추가할 수 있습니다.
      },
      (keywords) {
        trendingKeywords
          ..clear()
          ..addAll(keywords);
      },
    );
  }

  Future<List<Article>> onHandleFetchArticlesBySearch(
    String keyword, {
    bool refresh = false,
  }) async {
    if (_shouldResetSearch(refresh, keyword)) {
      _resetSearchState();
      isInitLoading.value = true; // 초기 로딩 상태 설정
    }

    if (!hasMoreSearchData.value || isSearchLoading.value) {
      return searchArticles;
    }

    isSearchLoading.value = true;

    try {
      return await _fetchSearchResults(keyword);
    } finally {
      isInitLoading.value = false; // 초기 로딩 상태 해제
      isSearchLoading.value = false; // 추가 페이지 로딩 상태 해제
    }
  }

  bool _shouldResetSearch(bool refresh, String keyword) {
    return refresh || currentQuery.value != keyword;
  }

  void _resetSearchState() {
    currentPage.value = 1;
    hasMoreSearchData.value = true;
    searchArticles.clear();
  }

  Future<List<Article>> _fetchSearchResults(String keyword) async {
    final params = GetSearchArticlesParams(
      query: keyword,
      page: currentPage.value,
      size: pageSize,
    );

    final result = await articleService.onHandleFetchSearchArticles(params);
    _updateSearchState(keyword, result);
    return result;
  }

  void _updateSearchState(String keyword, List<Article> result) {
    currentQuery.value = keyword;

    if (result.isEmpty) {
      hasMoreSearchData.value = false;
    }

    if (currentPage.value == 1) {
      searchArticles.clear();
    }
    searchArticles.addAll(result);
    currentPage.value++;
  }

  Future<void> refreshSearch() async {
    if (currentQuery.value.isNotEmpty) {
      await onHandleFetchArticlesBySearch(currentQuery.value, refresh: true);
    }
  }

  void onHandleGoToSearchView(String? search) {
    Get.to(() => SearchView(keyword: search), transition: Transition.cupertino);
  }

  void onHandleGoToKeywordArticlesView(String keyword, List<String> ids) async {
    print('ids: $ids');
    List<int> articleIds = ids.map((e) => int.parse(e)).toList();
    List<Article> articles =
        await articleService.onHandleFetchArticlesByIds(articleIds);
    Get.to(
        () => KeywordArticlesView(
              keyword: keyword,
              articles: articles,
            ),
        transition: Transition.cupertino);
  }

  // 데이터 리프레시를 위한 메서드 추가
  Future<void> refreshCurrentContent() async {
    if (selectedContentType.value != null) {
      await _loadArticlesForContentType(selectedContentType.value!);
    }
  }
}
