import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/domain/model/user.model.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find();

  User? user;

  @override
  onInit() async {
    super.onInit();
    await _initialize();
  }

  onClickSubscriptionManagement() {
    bool isLoggedIn = authService.isLoggedIn.value;
    print('isLoggedIn: $isLoggedIn');

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

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  /// 초기화
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  Future<void> _initialize() async {
    _listenUser();
  }

  void _listenUser() {
    authService.currentUser.listen((user) {
      if (user != null) {
        this.user = user;
      }
    });
  }
}
