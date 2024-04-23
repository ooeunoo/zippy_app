import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/channel_entity.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/user.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:zippy/domain/usecases/create_user_channel.dart';
import 'package:zippy/domain/usecases/delete_user_channel.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';

class ChannelController extends GetxController {
  final authController = Get.find<AuthController>();

  final GetChannels getChannels;
  final GetCategories getCategories;
  final CreateUserChannel createUserChannel;
  final DeleteUserChannel deleteUserChannel;
  final GetUserChannelByUserId getUserChannelByUserId;

  ChannelController(
    this.createUserChannel,
    this.deleteUserChannel,
    this.getUserChannelByUserId,
    this.getChannels,
    this.getCategories,
  );

  RxList<Channel> channels = RxList<Channel>([]).obs();
  RxList<Category> categories = RxList<Category>([]).obs();
  RxList<int> userSubscribeChannelIds = RxList<int>([]).obs();
  // RxList<int> userSubscribeCategoryIds = RxList<int>([]).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();
    await _setupChannel();
    await _setupUserChannel();
    await _setupCategories();
  }

  Future<void> toggleChannel(int channelId) async {
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      List<Category> channelCategories = categories
          .where((category) => category.channelId == channelId)
          .toList();

      List<UserChannelEntity> channels = [];

      for (Category category in channelCategories) {
        UserChannelEntity entity =
            UserChannel(userId: user.id, categoryId: category.id!)
                .toCreateEntity();
        channels.add(entity);
      }

      if (userSubscribeChannelIds.contains(channelId)) {
        await deleteUserChannel.execute(channels);
        userSubscribeChannelIds.remove(channelId);
      } else {
        await createUserChannel.execute(channels);
        userSubscribeChannelIds.add(channelId);
      }
    }
  }

  Future<void> _setupChannel() async {
    final result = await getChannels.execute();

    result.fold((failure) {}, (data) {
      channels.assignAll(data);
    });
  }

  Future<void> _setupUserChannel() async {
    UserModel? user = authController.getSignedUser();
    if (user != null) {
      final result = await getUserChannelByUserId.execute(
        user.id,
      );
      result.fold((failure) {
        if (failure == ServerFailure()) {
          error.value = 'Error Fetching Bookmark!';
        }
      }, (data) {
        List<int> channelIds = [];
        // List<int> categoryIds = [];
        for (var userChannel in data) {
          channelIds.add(userChannel.category!.channelId);
          // categoryIds.add(userChannel.categoryId);
        }
        userSubscribeChannelIds.assignAll(channelIds);
      });
    }
  }

  _setupCategories() async {
    UserModel? user = authController.user.value;
    if (user != null) {
      final result = await getCategories.execute();
      result.fold((failure) {
        if (failure == ServerFailure()) {
          error.value = 'Error Fetching Bookmark!';
        }
      }, (data) {
        List<Category> list = [];
        for (var category in data) {
          list.add(category);
        }
        categories.assignAll(list);
      });
    }
  }
}
