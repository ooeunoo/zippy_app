import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/usecases/create_user_category.dart';
import 'package:zippy/domain/usecases/delete_user_category.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_category.dart';
import 'package:zippy/domain/usecases/reset_user_category.dart';
import 'package:zippy/domain/usecases/subscirbe_user_category%20.dart';

class ChannelController extends GetxController {
  final GetChannels getChannels;
  final GetCategories getCategories;
  final CreateUserCategory createUserCategory;
  final DeleteUserCategory deleteUserCategory;
  final ResetUserCategory resetUserCategory;
  final GetUserCategory getUserCategory;
  final SubscribeUserCategory subscribeUserCategory;

  ChannelController(
    this.createUserCategory,
    this.deleteUserCategory,
    this.resetUserCategory,
    this.getUserCategory,
    this.getChannels,
    this.getCategories,
    this.subscribeUserCategory,
  );

  RxList<Category> categories = RxList<Category>([]).obs();
  RxList<Channel> communities = RxList<Channel>([]).obs();
  RxList<Channel> news = RxList<Channel>([]).obs();
  RxList<UserCategory> userSubscribeCategories = RxList<UserCategory>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> toggleChannel(int channelId) async {
    List<Category> channelCategories = categories
        .where((category) => category.channelId == channelId)
        .toList();

    List<UserCategoryEntity> userCategories = [];

    for (Category category in channelCategories) {
      UserCategoryEntity entity = UserCategory(
              id: category.id!,
              channelId: category.channelId,
              name: category.name)
          .toCreateEntity();
      userCategories.add(entity);
    }

    if (isAlreadySubscribeChannel(channelId)) {
      await deleteUserCategory.execute(userCategories);
    } else {
      await createUserCategory.execute(userCategories);
    }
  }

  bool isAlreadySubscribeChannel(int channelId) {
    return userSubscribeCategories
        .any((category) => category.channelId == channelId);
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
    await _setupUserCategory();
    await _setupChannels();
    await _setupCategories();
    _listenUserCategories();
  }

  Future<void> _setupUserCategory() async {
    final categories = await getUserCategory.execute();
    categories.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      userSubscribeCategories.assignAll(data);
    });
  }

  Future<void> _setupChannels() async {
    final result = await getChannels.execute(withCategory: true);

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      for (var channel in data) {
        if (channel.type == ChannelType.community.name) {
          communities.add(channel);
        } else if (channel.type == ChannelType.news.name) {
          news.add(channel);
        }
      }
    });
  }

  Future<void> _setupCategories() async {
    final result = await getCategories.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching category!';
      }
    }, (data) {
      List<Category> list = [];
      for (var category in data) {
        list.add(category);
      }
      categories.assignAll(list);
    });
  }

  void _listenUserCategories() {
    subscribeUserCategory.execute().listen((List<UserCategory> event) {
      print(event);
      userSubscribeCategories.bindStream(Stream.value(event));
    });
  }
}
