import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/domain/model/params/create_user_feedback.params.dart';
import 'package:zippy/domain/usecases/create_user_feedback.usecase.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find();

  final CreateUserFeedback createUserFeedback = Get.find();

  //////////////////////////////////////////////////////////////////
  /// public methods
  //////////////////////////////////////////////////////////////////

  ///onHandleFeedback
  void onHandleCreateFeedback(String feedback) {
    final currentUser = authService.currentUser.value;
    String? userId;
    if (currentUser != null) {
      userId = currentUser.id;
    }

    createUserFeedback
        .execute(CreateUserFeedbackParams(feedback: feedback, userId: userId));
  }

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
