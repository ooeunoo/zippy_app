import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/community_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_community_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/community_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_community_data_source.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/community_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_community_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/community_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_community_repository.dart';
import 'package:zippy/domain/usecases/create_user_community.dart';
import 'package:zippy/domain/usecases/delete_user_community.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_communities.dart';
import 'package:zippy/domain/usecases/get_user_community_by_user_id.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/subscribe_channel/subscribe_channel_controller.dart';

class SubscribeChannelBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryDatasource>(() => CategoryDatasourceIml());
    Get.lazyPut<CommunityDatasource>(() => CommunityDatasourceIml());
    Get.lazyPut<UserCommunityDatasource>(() => UserCommunityDatasourceIml());

    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut<CommunityRepository>(() => CommunityRepositoryImpl(Get.find()));
    Get.lazyPut<UserCommunityRepository>(
        () => UserCommunityRepositoryImpl(Get.find()));

    Get.lazyPut<GetCommunites>(() => GetCommunites(Get.find()));
    Get.lazyPut<GetCategories>(() => GetCategories(Get.find()));
    Get.lazyPut<CreateUserCommunity>(() => CreateUserCommunity(Get.find()));
    Get.lazyPut<DeleteUserCommunity>(() => DeleteUserCommunity(Get.find()));
    Get.lazyPut<GetUserCommunityByUserId>(
        () => GetUserCommunityByUserId(Get.find()));

    Get.lazyPut<SubscribeChannelController>(() => SubscribeChannelController(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
