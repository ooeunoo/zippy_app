import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  //////////////////////////////////////////////////////////////////
  /// public methods
  //////////////////////////////////////////////////////////////////

  void onClickSubscriptionManagement() {
    if (authService.isLoggedIn.value) {
      Get.toNamed(Routes.subscription);
    } else {
      _showLoginDialog();
    }
  }

  Future<void> onClickLogout() async {
    await authService.logout();
  }

  //////////////////////////////////////////////////////////////////
  /// private methods
  //////////////////////////////////////////////////////////////////

  void _showLoginDialog() {
    showAppDialog(
      "로그인이 필요해요.",
      confirmText: "로그인하러가기",
      onlyConfirm: true,
      onConfirm: () {
        Get.toNamed(Routes.login);
      },
    );
  }
}
