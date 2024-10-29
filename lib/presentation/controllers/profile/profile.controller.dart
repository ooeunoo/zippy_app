import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/widgets/app_dialog.dart';

import 'package:zippy/presentation/controllers/auth/auth.controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find();

  @override
  onInit() async {
    super.onInit();
  }

  onClickSubscriptionManagement() {
    bool isLoggedIn = authController.currentUser.value != null;

    if (isLoggedIn) {
      Get.toNamed(Routes.platform);
    } else {
      showAppDialog(
        "로그인이 필요합니다.",
        "로그인 후 이용해주세요.",
        confirmText: "로그인하러가기",
        onConfirm: () {
          Get.toNamed(Routes.login);
        },
      );
    }
  }
}
