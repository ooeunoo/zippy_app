import 'package:get/get.dart';
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
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
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscribeArticles>(() => SubscribeArticles(Get.find()));
    Get.lazyPut<GetPlatforms>(() => GetPlatforms(Get.find()));
    Get.lazyPut<GetSources>(() => GetSources());
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
    Get.lazyPut<CreateUserInteraction>(() => CreateUserInteraction(Get.find()));
    Get.lazyPut<UpdateUserInteraction>(() => UpdateUserInteraction(Get.find()));
    Get.lazyPut<GetArticleComments>(() => GetArticleComments());
    Get.lazyPut<CreateArticleComment>(() => CreateArticleComment());
    Get.lazyPut<BoardController>(() => BoardController());
  }
}
