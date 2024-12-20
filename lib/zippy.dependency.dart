import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/data/providers/kakao.provider.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/data/sources/article_comment.source.dart';
import 'package:zippy/data/sources/auth.source.dart';
import 'package:zippy/data/sources/content_type.source.dart';
import 'package:zippy/data/sources/keyword_rank_snapshot.source.dart';
import 'package:zippy/data/sources/source.source.dart';
import 'package:zippy/data/sources/platform.source.dart';
import 'package:zippy/data/sources/user.source.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/data/sources/user_interaction.source.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:zippy/domain/repositories/article.repository.dart';
import 'package:zippy/domain/repositories/article_comment.repository.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';
import 'package:zippy/domain/repositories/content_type.repository.dart';
import 'package:zippy/domain/repositories/keyword_rank_snapshot.repository.dart';
import 'package:zippy/domain/repositories/source.repository.dart';
import 'package:zippy/domain/repositories/platform.repository.dart';
import 'package:zippy/domain/repositories/user.repository.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/repositories/user_interaction.repository.dart';
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
import 'package:zippy/domain/usecases/get_search_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:zippy/domain/usecases/get_current_user.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_random_articles.dart';
import 'package:zippy/domain/usecases/get_recommend_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_top_articles_by_content_type.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmarks.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/logout.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark_folder.usecase.dart';
import 'package:zippy/domain/usecases/subscribe_auth_status.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';

class ZippyBindings implements Bindings {
  @override
  void dependencies() {
    _initProvider();
    _initDatasource();
    _initRepository();
    _initUsecase();
    _initService();
  }

  _initProvider() {
    SupabaseProvider.init();
    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);
    KakaoProvider.init();
    Get.put<KakaoProvider>(KakaoProvider(), permanent: true);
  }

  void _initDatasource() {
    Get.lazyPut<ArticleDatasource>(() => ArticleDatasourceImpl());
    Get.lazyPut<AuthDatasource>(() => AuthDatasourceImpl());
    Get.lazyPut<PlatformDatasource>(() => PlatformDatasourceImpl());
    Get.lazyPut<SourceDatasource>(() => SourceDatasourceImpl());
    Get.lazyPut<UserBookmarkDatasource>(() => UserBookmarkDatasourceImpl());
    Get.lazyPut<UserInteractionDatasource>(
        () => UserInteractionDatasourceImpl());
    // Get.lazyPut<UserSubscriptionDatasource>(
    //     () => UserSubscriptionDatasourceImpl());
    Get.lazyPut<UserDatasource>(() => UserDatasourceImpl());
    Get.lazyPut<ContentTypeDatasource>(() => ContentTypeDatasourceImpl());
    Get.lazyPut<ArticleCommentDatasource>(() => ArticleCommentDatasourceImpl());
    Get.lazyPut<KeywordRankSnapshotDatasource>(
        () => KeywordRankSnapshotDatasourceImpl());
  }

  void _initRepository() {
    Get.lazyPut<AppMetadataRepository>(
        () => AppMetadataRepositoryImpl(Get.find()));
    Get.lazyPut<ArticleRepository>(() => ArticleRepositoryImpl(Get.find()));
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<PlatformRepository>(() => PlatformRepositoryImpl(Get.find()));
    Get.lazyPut<SourceRepository>(() => SourceRepositoryImpl(Get.find()));
    Get.lazyPut<UserBookmarkRepository>(
        () => UserBookmarkRepositoryImpl(Get.find()));
    Get.lazyPut<UserInteractionRepository>(
        () => UserInteractionRepositoryImpl(Get.find()));
    // Get.lazyPut<UserSubscriptionRepository>(
    //     () => UserSubscriptionRepositoryImpl(Get.find()));
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
    Get.lazyPut<ContentTypeRepository>(
        () => ContentTypeRepositoryImpl(Get.find()));
    Get.lazyPut<ArticleCommentRepository>(
        () => ArticleCommentRepositoryImpl(Get.find()));
    Get.lazyPut<KeywordRankSnapshotRepository>(
        () => KeywordRankSnapshotRepositoryImpl(Get.find()));
  }

  void _initUsecase() {
    Get.lazyPut<GetCurrentUser>(() => GetCurrentUser(Get.find()));
    Get.lazyPut<SubscribeAuthStatus>(() => SubscribeAuthStatus(Get.find()));
    Get.lazyPut<GetContentTypes>(() => GetContentTypes());
    Get.lazyPut<Logout>(() => Logout(Get.find()));
    Get.lazyPut<GetPlatforms>(() => GetPlatforms(Get.find()));
    Get.lazyPut<GetSources>(() => GetSources());
    Get.lazyPut<GetSearchArticles>(() => GetSearchArticles());
    Get.lazyPut<GetUserBookmarks>(() => GetUserBookmarks(Get.find()));
    Get.lazyPut<CreateUserBookmark>(() => CreateUserBookmark(Get.find()));
    Get.lazyPut<DeleteUserBookmark>(() => DeleteUserBookmark(Get.find()));
    Get.lazyPut<SubscribeUserBookmark>(() => SubscribeUserBookmark(Get.find()));
    // Get.lazyPut<GetUserSubscriptionsStream>(
    //     () => GetUserSubscriptionsStream(Get.find()));
    // Get.lazyPut<GetUserSubscriptions>(() => GetUserSubscriptions(Get.find()));
    Get.lazyPut<CreateUserInteraction>(() => CreateUserInteraction(Get.find()));
    Get.lazyPut<UpdateUserInteraction>(() => UpdateUserInteraction(Get.find()));
    Get.lazyPut<GetArticleComments>(() => GetArticleComments());
    Get.lazyPut<CreateArticleComment>(() => CreateArticleComment());
    Get.lazyPut<GetRecommendedArticles>(() => GetRecommendedArticles());
    Get.lazyPut<GetRandomArticles>(() => GetRandomArticles());
    Get.lazyPut<GetContentTypes>(() => GetContentTypes());
    // Get.lazyPut<ToggleUserSubscription>(
    //     () => ToggleUserSubscription(Get.find()));
    Get.lazyPut<CreateUserBookmarkFolder>(
        () => CreateUserBookmarkFolder(Get.find()));
    Get.lazyPut<GetUserBookmarkFolders>(
        () => GetUserBookmarkFolders(Get.find()));
    Get.lazyPut<DeleteUserBookmarkFolder>(
        () => DeleteUserBookmarkFolder(Get.find()));
    Get.lazyPut<SubscribeUserBookmarkFolder>(
        () => SubscribeUserBookmarkFolder(Get.find()));
    Get.lazyPut<GetTopArticlesByContentType>(
        () => GetTopArticlesByContentType(Get.find()));
  }

  _initService() {
    Get.put<WebViewService>(WebViewService(), permanent: true);
    Get.put<AdmobService>(AdmobService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ContentTypeService>(ContentTypeService(), permanent: true);
    Get.put<BookmarkService>(BookmarkService(), permanent: true);
    Get.put<ArticleService>(ArticleService(), permanent: true);
    // Get.put<SubscriptionService>(SubscriptionService(), permanent: true);
  }
}
