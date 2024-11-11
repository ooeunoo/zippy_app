import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_articles_by_keyword.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetArticles());
    Get.lazyPut(() => GetContentTypes());
    Get.lazyPut(() => GetArticlesByKeyword());
    Get.lazyPut(() => GetTrendingKeywords());
    Get.lazyPut(() => AppSearchController());
  }
}
