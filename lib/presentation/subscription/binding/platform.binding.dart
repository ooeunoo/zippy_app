import 'package:zippy/domain/usecases/create_user_source.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_category.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/reset_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/presentation/subscription/controller/subscription.controller.dart';

class PlatformBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetPlatforms>(() => GetPlatforms(Get.find()));
    Get.lazyPut<GetSources>(() => GetSources(Get.find()));
    Get.lazyPut<CreateUserSubscription>(
        () => CreateUserSubscription(Get.find()));
    Get.lazyPut<DeleteUserSubscription>(
        () => DeleteUserSubscription(Get.find()));
    Get.lazyPut<ResetUserSubscription>(() => ResetUserSubscription(Get.find()));
    Get.lazyPut<SubscribeUserSubscriptions>(
        () => SubscribeUserSubscriptions(Get.find()));

    Get.lazyPut<PlatformController>(() => PlatformController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find()));
  }
}
