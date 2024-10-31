import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/sources/app_metadata.source.dart';
import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/data/sources/auth.source.dart';
import 'package:zippy/data/sources/bookmark.source.dart';
import 'package:zippy/data/sources/source.source.dart';
import 'package:zippy/data/sources/platform.source.dart';
import 'package:zippy/data/sources/user.source.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/data/sources/user_interaction.source.dart';
import 'package:zippy/data/sources/user_subscription.source.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:zippy/domain/repositories/article.repository.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';
import 'package:zippy/domain/repositories/bookmark.repository.dart';
import 'package:zippy/domain/repositories/source.repository.dart';
import 'package:zippy/domain/repositories/platform.repository.dart';
import 'package:zippy/domain/repositories/user.repository.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/repositories/user_interaction.repository.dart';
import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
import 'package:zippy/domain/usecases/get_current_user.usecase.dart';
import 'package:zippy/domain/usecases/logout.usecase.dart';
import 'package:zippy/domain/usecases/subscribe_auth_status.usecase.dart';
import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';

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
  }

  _initService() {
    Get.put<AdmobService>(AdmobService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
  }

  void _initDatasource() {
    Get.lazyPut<AppMetadataDatasource>(() => AppMetadataDatasourceImpl());
    Get.lazyPut<ArticleDatasource>(() => ArticleDatasourceImpl());
    Get.lazyPut<AuthDatasource>(() => AuthDatasourceImpl());
    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceImpl());
    Get.lazyPut<PlatformDatasource>(() => PlatformDatasourceImpl());
    Get.lazyPut<SourceDatasource>(() => SourceDatasourceImpl());
    Get.lazyPut<UserBookmarkDatasource>(() => UserBookmarkDatasourceImpl());
    Get.lazyPut<UserInteractionDatasource>(
        () => UserInteractionDatasourceImpl());
    Get.lazyPut<UserSubscriptionDatasource>(
        () => UserSubscriptionDatasourceImpl());
    Get.lazyPut<UserDatasource>(() => UserDatasourceImpl());
  }

  void _initRepository() {
    Get.lazyPut<AppMetadataRepository>(
        () => AppMetadataRepositoryImpl(Get.find()));
    Get.lazyPut<ArticleRepository>(() => ArticleRepositoryImpl(Get.find()));
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));
    Get.lazyPut<PlatformRepository>(() => PlatformRepositoryImpl(Get.find()));
    Get.lazyPut<SourceRepository>(() => SourceRepositoryImpl(Get.find()));
    Get.lazyPut<UserBookmarkRepository>(
        () => UserBookmarkRepositoryImpl(Get.find()));
    Get.lazyPut<UserInteractionRepository>(
        () => UserInteractionRepositoryImpl(Get.find()));
    Get.lazyPut<UserSubscriptionRepository>(
        () => UserSubscriptionRepositoryImpl(Get.find()));
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
  }

  void _initUsecase() {
    Get.lazyPut<GetAppMetadata>(() => GetAppMetadata(Get.find()));
    Get.lazyPut<UpdateAppMetadata>(() => UpdateAppMetadata(Get.find()));
    Get.lazyPut<GetCurrentUser>(() => GetCurrentUser(Get.find()));
    Get.lazyPut<SubscribeAuthStatus>(() => SubscribeAuthStatus(Get.find()));
    Get.lazyPut<Logout>(() => Logout(Get.find()));
  }
}
