import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/domain/model/params/get_tranding_keywords.params.dart';
import 'package:zippy/domain/usecases/get_trending_keywords.usecase.dart';

class AppSearchController extends GetxController {
  final ContentTypeService contentTypeService = Get.find();
  final AuthService authService = Get.find();

  final GetTrendingKeywords getTrendingKeywords = Get.find();

  RxMap<int, List<KeywordRankSnapshot>> trendingKeywordsByContentType =
      RxMap<int, List<KeywordRankSnapshot>>({});

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> onHandleTrendingKeywords(ContentType? contentType) async {
    final params = GetTrandingKeywordsParams(contentType: contentType);
    final result = await getTrendingKeywords.execute(params);
    result.fold(
        (l) => null,
        (keywords) =>
            trendingKeywordsByContentType[contentType?.id ?? 0] = keywords);
  }

  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _fetchAllTrendingKeywords();
  }

  Future<void> _fetchAllTrendingKeywords() async {
    await onHandleTrendingKeywords(null);
    for (var contentType in contentTypeService.contentTypes) {
      await onHandleTrendingKeywords(contentType);
    }
  }
}
