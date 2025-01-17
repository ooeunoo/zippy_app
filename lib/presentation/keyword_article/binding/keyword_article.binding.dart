import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_articles_by_ids.usecase.dart';
import 'package:zippy/domain/usecases/get_articles_by_keyword.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';
import 'package:zippy/presentation/keyword_article/controller/keyword_article.controller.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';

class KeywordArticleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetArticlesByIds());
    Get.lazyPut(() => KeywordArticleController());
  }
}
