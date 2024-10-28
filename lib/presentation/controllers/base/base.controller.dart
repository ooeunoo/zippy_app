
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/presentation/pages/board/board_view.dart';
import 'package:zippy/presentation/pages/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  late PageController pageController;

  var currentPage = 0.obs;

  List<Widget> pages = [
    const BoardView(),
    const ProfileView(),
  ];

  void goToTab(int page) {
    onHeavyVibration();
    currentPage.value = page;
  }
}
