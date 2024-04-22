import 'package:cocomu/presentation/pages/board/board.dart';
import 'package:cocomu/presentation/pages/profile/profile.dart';
import 'package:cocomu/presentation/pages/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  late PageController pageController;

  var currentPage = 0.obs;

  List<Widget> pages = [
    const Board(),
    const Search(),
    const Profile(),
  ];

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
