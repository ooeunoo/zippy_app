import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/data/sources/bookmark.source.dart';
import 'package:zippy/data/sources/source.source.dart';
import 'package:zippy/data/sources/platform.source.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/repositories/article.repository.dart';
import 'package:zippy/domain/repositories/bookmark.repository.dart';
import 'package:zippy/domain/repositories/source.repository.dart';
import 'package:zippy/domain/repositories/platform.repository.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_articles.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/up_article_report_count.usecase.dart';
import 'package:zippy/domain/usecases/up_article_view_count.usecase.dart';
import 'package:zippy/presentation/controllers/base/base.controller.dart';
import 'package:zippy/presentation/controllers/board/board.controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(BaseController(), permanent: true);

    Get.lazyPut<PlatformDatasource>(() => PlatformDatasourceIml());
    Get.lazyPut<PlatformRepository>(() => PlatformRepositoryImpl(Get.find()));

    Get.lazyPut<SourceDatasource>(() => SourceDatasourceIml());
    Get.lazyPut<SourceRepository>(() => SourceRepositoryImpl(Get.find()));

    Get.lazyPut<ArticleDatasource>(() => ArticleDatasourceImpl());
    Get.lazyPut<ArticleRepository>(() => ArticleRepositoryImpl(Get.find()));

    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceIml());
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<UserSubscriptionDatasource>(
        () => UserSubscriptionDatasourceImpl());
    Get.lazyPut<UserSubscriptionRepository>(
        () => UserSubscriptionRepositoryImpl(Get.find()));

    Get.lazyPut<UserBookmarkDatasource>(() => UserBookmarkDatasourceImpl());
    Get.lazyPut<UserBookmarkRepository>(
        () => UserBookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<SubscribeArticles>(() => SubscribeArticles(Get.find()));
    Get.lazyPut<GetPlatforms>(() => GetPlatforms(Get.find()));
    Get.lazyPut<GetSources>(() => GetSources(Get.find()));
    Get.lazyPut<GetArticles>(() => GetArticles(Get.find()));
    Get.lazyPut<GetUserBookmark>(() => GetUserBookmark(Get.find()));
    Get.lazyPut<CreateUserBookmark>(() => CreateUserBookmark(Get.find()));
    Get.lazyPut<DeleteUserBookmark>(() => DeleteUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserBookmark>(() => SubscribeUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserSubscriptions>(
        () => SubscribeUserSubscriptions(Get.find()));
    Get.lazyPut<GetUserSubscriptions>(() => GetUserSubscriptions(Get.find()));
    Get.lazyPut<UpArticleViewCount>(() => UpArticleViewCount(Get.find()));
    Get.lazyPut<UpArticleReportCount>(() => UpArticleReportCount(Get.find()));

    Get.lazyPut<BoardController>(
      () => BoardController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find()),
    );
  }
}
