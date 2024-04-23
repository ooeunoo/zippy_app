import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/channel_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_channel_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_channel_data_source.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/channel;_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_channel_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';
import 'package:zippy/domain/usecases/create_user_channel.dart';
import 'package:zippy/domain/usecases/delete_user_channel.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/channel/channel_controller.dart';

class ChannelBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryDatasource>(() => CategoryDatasourceIml());
    Get.lazyPut<ChannelDatasource>(() => ChannelDatasourceIml());
    Get.lazyPut<UserChannelDatasource>(() => UserChannelDatasourceIml());

    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut<ChannelRepository>(() => ChannelRepositoryImpl(Get.find()));
    Get.lazyPut<UserChannelRepository>(
        () => UserChannelRepositoryImpl(Get.find()));

    Get.lazyPut<GetChannels>(() => GetChannels(Get.find()));
    Get.lazyPut<GetCategories>(() => GetCategories(Get.find()));
    Get.lazyPut<CreateUserChannel>(() => CreateUserChannel(Get.find()));
    Get.lazyPut<DeleteUserChannel>(() => DeleteUserChannel(Get.find()));
    Get.lazyPut<GetUserChannelByUserId>(
        () => GetUserChannelByUserId(Get.find()));

    Get.lazyPut<ChannelController>(() => ChannelController(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
