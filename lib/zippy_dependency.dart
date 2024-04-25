import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/implementations/bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/channel_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/item_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/data/sources/interfaces/item_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_data_source.dart';
import 'package:zippy/domain/repositories/implementations/bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/channel;_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/item_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_repository.dart';
import 'package:zippy/domain/usecases/get_user.dart';
import 'package:zippy/domain/usecases/login_with_kakao.dart';
import 'package:zippy/domain/usecases/logout.dart';
import 'package:zippy/domain/usecases/subscirbe_user.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';
import 'package:get/get.dart';
import 'package:zippy/data/sources/implementations/user_channel_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/user_channel_data_source.dart';
import 'package:zippy/domain/repositories/implementations/user_channel_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';
import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_channel.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';

class ZippyBindings implements Bindings {
  @override
  void dependencies() {
    SupabaseProvider.init();
    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);

    Get.put<UserDatasource>(UserDatasourceIml(), permanent: true);
    Get.put<UserRepository>(UserRepositoryImpl(Get.find()), permanent: true);

    Get.put<LoginWithKakao>(LoginWithKakao(Get.find()), permanent: true);
    Get.put<SubscribeUser>(SubscribeUser(Get.find()), permanent: true);
    Get.put<Logout>(Logout(Get.find()), permanent: true);
    Get.put<GetUser>(GetUser(Get.find()), permanent: true);

    Get.put<AuthController>(
        AuthController(Get.find(), Get.find(), Get.find(), Get.find()),
        permanent: true);

    Get.put<AdmobService>(AdmobService(), permanent: true);

    Get.lazyPut<ChannelDatasource>(() => ChannelDatasourceIml());
    Get.lazyPut<ChannelRepository>(() => ChannelRepositoryImpl(Get.find()));

    Get.lazyPut<CategoryDatasource>(() => CategoryDatasourceIml());
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));

    Get.lazyPut<ItemDatasource>(() => ItemDatasourceImpl());
    Get.lazyPut<ItemRepository>(() => ItemRepositoryImpl(Get.find()));

    Get.lazyPut<BookmarkDatasource>(() => BookmarkDatasourceIml());
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find()));

    Get.lazyPut<UserChannelDatasource>(() => UserChannelDatasourceIml());
    Get.lazyPut<UserChannelRepository>(
        () => UserChannelRepositoryImpl(Get.find()));

    Get.lazyPut<SubscribeItems>(() => SubscribeItems(Get.find()));
    Get.lazyPut<SubscribeUserChannel>(() => SubscribeUserChannel(Get.find()));
    Get.lazyPut<SubscribeUserBookmark>(() => SubscribeUserBookmark(Get.find()));
    Get.lazyPut<GetChannels>(() => GetChannels(Get.find()));
    Get.lazyPut<GetCategories>(() => GetCategories(Get.find()));
    Get.lazyPut<GetBookmarksByUserId>(() => GetBookmarksByUserId(Get.find()));
    Get.lazyPut<CreateBookmark>(() => CreateBookmark(Get.find()));
    Get.lazyPut<DeleteBookmark>(() => DeleteBookmark(Get.find()));
    Get.lazyPut<GetUserChannelByUserId>(
        () => GetUserChannelByUserId(Get.find()));

    Get.put<BoardController>(
        BoardController(Get.find(), Get.find(), Get.find(), Get.find(),
            Get.find(), Get.find(), Get.find(), Get.find(), Get.find()),
        permanent: true);
  }
}
