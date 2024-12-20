import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_top_articles_by_content_type.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<GetTrendingKeywords>(GetTrendingKeywords(Get.find()));
    Get.put<GetTopArticlesByContentType>(
        GetTopArticlesByContentType(Get.find()));
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
