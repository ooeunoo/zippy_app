import 'package:zippy/domain/usecases/create_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/presentation/subscription/controller/subscription.controller.dart';

class SubscriptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetContentTypes>(() => GetContentTypes());
    Get.lazyPut<CreateUserSubscription>(
        () => CreateUserSubscription(Get.find()));
    Get.lazyPut<DeleteUserSubscription>(
        () => DeleteUserSubscription(Get.find()));
    Get.lazyPut<SubscribeUserSubscriptions>(
        () => SubscribeUserSubscriptions(Get.find()));

    Get.lazyPut<SubscriptionController>(() => SubscriptionController(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
