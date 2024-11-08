import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetContentTypes());
    Get.lazyPut(() => GetTrendingKeywords());
    Get.lazyPut(() => AppSearchController());
  }
}
