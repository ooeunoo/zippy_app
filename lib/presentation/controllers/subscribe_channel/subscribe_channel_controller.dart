import 'package:get/get.dart';
import 'package:zippy/domain/model/community.dart';
import 'package:zippy/domain/usecases/create_user_community.dart';
import 'package:zippy/domain/usecases/delete_user_community.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_communities.dart';
import 'package:zippy/domain/usecases/get_user_community_by_user_id.dart';

class SubscribeChannelController extends GetxController {
  final GetCommunites getCommunites;
  final GetCategories getCategories;
  final CreateUserCommunity createUserCommunity;
  final DeleteUserCommunity deleteUserCommunity;
  final GetUserCommunityByUserId getUserCommunityByUserId;

  SubscribeChannelController(
    this.createUserCommunity,
    this.deleteUserCommunity,
    this.getUserCommunityByUserId,
    this.getCommunites,
    this.getCategories,
  );

  RxList<Community> communities = RxList<Community>([]).obs();

  @override
  onInit() async {
    super.onInit();
    await _setupCommunity();
  }

  Future<void> _setupCommunity() async {
    final result = await getCommunites.execute();

    result.fold((failure) {}, (data) {
      communities.assignAll(data);
    });
  }
}
