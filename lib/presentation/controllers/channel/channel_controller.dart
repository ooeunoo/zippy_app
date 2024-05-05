import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/utils/log.dart';
import 'package:zippy/data/entity/user_category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/usecases/create_user_category.dart';
import 'package:zippy/domain/usecases/delete_user_category.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_category.dart';
import 'package:zippy/domain/usecases/subscirbe_user_category%20.dart';
import 'package:zippy/presentation/pages/channel/widgets/channel_category.dart';

class ChannelController extends GetxController {
  final GetChannels getChannels;
  final GetCategories getCategories;
  final CreateUserCategory createUserCategory;
  final DeleteUserCategory deleteUserCategory;
  final GetUserCategory getUserCategory;
  final SubscribeUserCategory subscribeUserCategory;

  ChannelController(
      this.createUserCategory,
      this.deleteUserCategory,
      this.getUserCategory,
      this.getChannels,
      this.getCategories,
      this.subscribeUserCategory);

  RxList<Channel> communities = RxList<Channel>([]).obs();
  RxList<Channel> news = RxList<Channel>([]).obs();
  Rx<Map<int, List<UserCategory>>> userSubscribeCategories =
      Rx<Map<int, List<UserCategory>>>({}).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> toggleCategory(Channel channel, Category category) async {
    UserCategoryEntity entity = UserCategory(
            id: category.id!,
            channelId: category.channelId,
            name: category.name)
        .toCreateEntity();

    if (isAlreadySubscribeCategory(channel.id!, category.id!)) {
      await deleteUserCategory.execute([entity]);
    } else {
      await createUserCategory.execute([entity]);
    }
  }

  void onClickChannel(Channel channel) {
    Get.to(
        () => ChannelCategory(
              channel: channel,
              toggleCategory: toggleCategory,
            ),
        transition: Transition.rightToLeftWithFade);
  }

  bool isAlreadySubscribeCategory(int channelId, int categoryId) {
    if (userSubscribeCategories.value.containsKey(channelId)) {
      List<UserCategory> categories = userSubscribeCategories.value[channelId]!;
      return categories.any((category) => category.id == categoryId);
    }
    return false;
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    await _setupUserCategory();
    await _setupChannels();
    _listenUserCategories();
  }

  Future<void> _setupUserCategory() async {
    final categories = await getUserCategory.execute();
    categories.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Error Fetching channel!';
      }
    }, (data) {
      Map<int, List<UserCategory>> groupedCategories = _groupByChannelId(data);
      userSubscribeCategories.value = groupedCategories;
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

  void _listenUserCategories() {
    subscribeUserCategory.execute().listen((List<UserCategory> event) {
      Map<int, List<UserCategory>> groupedCategories = _groupByChannelId(event);
      userSubscribeCategories.value = groupedCategories;
    });
  }

  Map<int, List<UserCategory>> _groupByChannelId(
      List<UserCategory> userCategories) {
    Map<int, List<UserCategory>> groupedMap = {};
    for (var category in userCategories) {
      if (!groupedMap.containsKey(category.channelId)) {
        groupedMap[category.channelId] = [];
      }
      groupedMap[category.channelId]!.add(category);
    }
    return groupedMap;
  }
}
