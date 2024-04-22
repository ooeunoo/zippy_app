import 'package:zippy/presentation/pages/board/board.dart';
import 'package:zippy/presentation/pages/profile/profile.dart';
import 'package:zippy/presentation/pages/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  late PageController pageController;

  var currentPage = 0.obs;

  List<Widget> pages = [
    const Board(),
    // const Search(),
    const Profile(),
  ];

  BaseController() {
    ever(currentPage, (v) => print(v));
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
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
