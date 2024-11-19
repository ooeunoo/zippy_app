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

  //////////////////////////////////////////////////////////////////
  /// private methods
  //////////////////////////////////////////////////////////////////
}
