import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find();

  @override
  onInit() async {
    super.onInit();
  }

  onClickSubscriptionManagement() {
    bool isLoggedIn = authService.isLoggedIn.value;
    print(isLoggedIn);
    if (isLoggedIn) {
      Get.toNamed(Routes.platform);
    } else {
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

  onClickLogout() async {
    await authService.logout();
  }
}
