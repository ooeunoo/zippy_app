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
  Rxn<String> error = Rxn<String>();
  RxList<UserCategory> userSubscribeCategories = RxList<UserCategory>([]).obs();

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> toggleCategory(Category category) async {
    UserCategoryEntity entity = UserCategory(
            id: category.id!,
            channelId: category.channelId,
            name: category.name)
        .toCreateEntity();

    if (isAlreadySubscribeCategory(category.id!)) {
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

  bool isAlreadySubscribeCategory(int categoryId) {
    return userSubscribeCategories.any((category) => category.id == categoryId);
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

  void _listenUserCategories() {
    subscribeUserCategory.execute().listen((List<UserCategory> event) {
      userSubscribeCategories.bindStream(Stream.value(event));
    });
  }
}
