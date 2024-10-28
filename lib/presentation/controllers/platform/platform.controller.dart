import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_subscription.entity.dart';
import 'package:zippy/domain/enum/platform_type.enum.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_user_source.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_category.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/reset_user_subscription.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';

class PlatformController extends GetxController {
  final GetPlatforms getPlatforms;
  final GetSources getSources;
  final CreateUserSubscription createUserSubscription;
  final DeleteUserSubscription deleteUserSubscription;
  final ResetUserSubscription resetUserSubscription;
  final GetUserSubscriptions getUserSubscriptions;
  final SubscribeUserSubscriptions subscribeUserSubscriptions;

  PlatformController(
    this.createUserSubscription,
    this.deleteUserSubscription,
    this.resetUserSubscription,
    this.getUserSubscriptions,
    this.getPlatforms,
    this.getSources,
    this.subscribeUserSubscriptions,
  );

  RxList<Source> sources = RxList<Source>([]).obs();
  RxList<Platform> communities = RxList<Platform>([]).obs();
  RxList<Platform> news = RxList<Platform>([]).obs();
  RxList<UserSubscription> userSubscriptions =
      RxList<UserSubscription>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> togglePlatform(int platformId) async {
    List<Source> platformSources =
        sources.where((source) => source.platformId == platformId).toList();

    List<UserSubscriptionEntity> userSubscriptions = [];

    for (Source source in platformSources) {
      UserSubscriptionEntity entity = UserSubscription(
        id: source.id!,
        platformId: source.platformId,
      ).toCreateEntity();
      userSubscriptions.add(entity);
    }

    if (isAlreadySubscribePlatform(platformId)) {
      await deleteUserSubscription.execute(userSubscriptions);
    } else {
      await createUserSubscription.execute(userSubscriptions);
    }
  }

  bool isAlreadySubscribePlatform(int platformId) {
    return userSubscriptions
        .any((subscription) => subscription.platformId == platformId);
  }

  // void onClickChannel(Channel channel) {
  //   Get.to(
  //       () => ChannelCategory(
  //             channel: channel,
  //             toggleCategory: toggleCategory,
  //           ),
  //       transition: Transition.rightToLeftWithFade);
  // }

  // bool isAlreadySubscribeCategory(int channelId, int categoryId) {
  //   if (userSubscribeCategories.value.containsKey(channelId)) {
  //     List<UserCategory> categories = userSubscribeCategories.value[channelId];
  //     return categories.any((category) => category.id == categoryId);
  //   }
  //   return false;
  // }

  // void resetAllSubscribeCategory() async {
  //   await resetUserCategory.execute();
  // }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _setupUserSubscriptions();
    await _setupChannels();
    await _setupSources();
    _listenUserSubscriptions();
  }

  Future<void> _setupUserSubscriptions() async {
    final subscriptions = await getUserSubscriptions.execute();
    subscriptions.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching subscription!';
      }
    }, (data) {
      userSubscriptions.assignAll(data);
    });
  }

  Future<void> _setupChannels() async {
    final result = await getPlatforms.execute(withSources: true);

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      for (var platform in data) {
        if (platform.type == PlatformType.Community.name) {
          communities.add(platform);
        } else if (platform.type == PlatformType.News.name) {
          news.add(platform);
        }
      }
    });
  }

  Future<void> _setupSources() async {
    final result = await getSources.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching category!';
      }
    }, (data) {
      List<Source> list = [];
      for (var source in data) {
        list.add(source);
      }
      sources.assignAll(list);
    });
  }

  void _listenUserSubscriptions() {
    subscribeUserSubscriptions.execute().listen((List<UserSubscription> event) {
      print(event);
      userSubscriptions.bindStream(Stream.value(event));
    });
  }
}
