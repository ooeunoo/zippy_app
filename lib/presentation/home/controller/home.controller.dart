import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_top_articles_by_content_type.params.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';
import 'package:zippy/domain/usecases/get_top_articles_by_content_type.usecase.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';

class HomeController extends GetxController {
  final GetTopArticlesByContentType getTopArticlesByContentType = Get.find();
  final GetTrendingKeywords getTrendingKeywords = Get.find();

  final topArticlesByContentType = RxList<TopArticlesByContentType>([]);
  final trendingKeywords = RxList<KeywordRankSnapshot>([]);

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    onHandleFetchTopArticlesByContentType();
    onHandleFetchTrendingKeywords();
  }

  Future<void> onHandleFetchTopArticlesByContentType() async {
    final result = await getTopArticlesByContentType
        .execute(const GetTopArticlesByContentTypeParams(
      timeRange: 30 * 24 * 60,
    ));
    result.fold((failure) {}, (articles) {
      topArticlesByContentType.clear();
      topArticlesByContentType.addAll(articles);
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
}
