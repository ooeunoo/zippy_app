import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/category.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:cocomu/domain/usecases/get_categories.dart';
import 'package:cocomu/domain/usecases/get_communities.dart';
import 'package:cocomu/domain/usecases/subscirbe_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  final SubscribeItems subscribeItems;
  final GetCommunites getCommunites;
  final GetCategories getCategories;

  BoardController(this.subscribeItems, this.getCommunites, this.getCategories);

  PageController pageController = PageController(initialPage: 0);

  RxList<Item> subscribers = RxList<Item>([]).obs();
  RxMap<int, Community> communities = RxMap<int, Community>({}).obs();
  RxMap<int, Category> categories = RxMap<int, Category>({}).obs();
  Rxn<String> error = Rxn<String>();

  @override
  onInit() async {
    super.onInit();

    subscribers.bindStream(subscribe());

    await _setupCommunity();
    await _setupCategories();
  }

  Stream<List<Item>> subscribe() {
    Stream<List<Item>> result = subscribeItems.execute();
    return result;
  }

  _setupCommunity() async {
    var result = await getCommunites.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Customer!";
      }
    }, (data) {
      Map<int, Community> map = {};
      for (var community in data) {
        map = community.toIdAssign(map);
      }
      communities.assignAll(map);
    });
  }

  _setupCategories() async {
    var result = await getCategories.execute();

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = "Error Fetching Customer!";
      }
    }, (data) {
      Map<int, Category> map = {};
      for (var category in data) {
        map = category.toIdAssign(map);
      }
      categories.assignAll(map);
    });
  }

  Community getCommunityByCategoryId(int categoryId) {
    return communities[categories[categoryId]!.communityId]!;
  }
}
