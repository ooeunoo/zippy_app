import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find();

  //////////////////////////////////////////////////////////////////
  /// public methods
  //////////////////////////////////////////////////////////////////

  void onClickSubscriptionManagement() {
    if (authService.isLoggedIn.value) {
      Get.toNamed(Routes.subscription);
    } else {
      showLoginDialog();
    }
  }

  void onClickBookmark() {
    if (authService.isLoggedIn.value) {
      Get.toNamed(Routes.bookmark);
    } else {
      showLoginDialog();
    }
  }

  void onClickKeywordNotification() {
    if (authService.isLoggedIn.value) {
      Get.toNamed(Routes.keywordNotification);
    } else {
      showLoginDialog();
    }
  }

  //////////////////////////////////////////////////////////////////
  /// private methods
  //////////////////////////////////////////////////////////////////
}
