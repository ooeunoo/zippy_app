import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// int SNACKBAR_DURATION = 1;
// notifyNoItems() {
//   Get.rawSnackbar(
//     messageText: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // AppSvg(Assets.check),
//         AppSpacerH(value: AppDimens.size(10)),
//         AppText(
//           '우측으로 이동해주세요',
//           align: TextAlign.center,
//           style: Theme.of(Get.context!).textTheme.textMD.copyWith(
//                 color: AppColor.gray900,
//                 fontWeight: AppFontWeight.regular,
//               ),
//         ),
//       ],
//     ),
//     forwardAnimationCurve: Curves.ease,
//     maxWidth: AppDimens.size(230),
//     backgroundColor: AppColor.brand500,
//     snackPosition: SnackPosition.BOTTOM,
//     borderRadius: AppDimens.size(16),
//     duration: Duration(seconds: SNACKBAR_DURATION),
//     animationDuration: const Duration(milliseconds: 1000), // 애니메이션 시간을 조정합니다.
//     padding: EdgeInsets.symmetric(
//       horizontal: AppDimens.width(20),
//       vertical: AppDimens.height(12),
//     ),
//     margin: EdgeInsets.symmetric(
//       vertical:
//           MediaQuery.of(Get.context!).padding.bottom + AppDimens.height(20),
//       horizontal: AppDimens.width(20),
//     ),
//   );
// }

notifyErrorMessage(String message) {
  Get.showSnackbar(
    GetSnackBar(
      // message: '이미 동일한 이메일로 가입된 계정이 있어요.',
      messageText: AppText(message,
          style: Theme.of(Get.context!)
              .textTheme
              .textMD
              .copyWith(color: AppColor.graymodern100)),
      duration: const Duration(seconds: 3),
      backgroundColor: AppColor.brand600,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      animationDuration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(15)),
    ),
  );
}

notifyReported() {
  Get.showSnackbar(
    GetSnackBar(
      messageText: AppText("신고되었습니다 ",
          align: TextAlign.center,
          style: Theme.of(Get.context!)
              .textTheme
              .textMD
              .copyWith(color: AppColor.graymodern100)),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColor.brand600,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      animationDuration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(15)),
    ),
  );
}

notifyBookmarked() {
  Get.showSnackbar(
    GetSnackBar(
      messageText: AppText("북마크되었습니다.",
          align: TextAlign.center,
          style: Theme.of(Get.context!)
              .textTheme
              .textMD
              .copyWith(color: AppColor.graymodern100)),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColor.brand600,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      animationDuration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(15)),
    ),
  );
}

notifyLogout() {
  Get.showSnackbar(
    GetSnackBar(
      messageText: AppText("로그아웃 되었습니다",
          align: TextAlign.center,
          style: Theme.of(Get.context!)
              .textTheme
              .textSM
              .copyWith(color: AppColor.graymodern300)),
      backgroundColor: AppColor.brand800,
      snackPosition: SnackPosition.TOP,
      borderRadius: AppDimens.size(10),
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: AppDimens.width(100)),
      // padding: EdgeInsets.symmetric(
      //     horizontal: AppDimens.width(20), vertical: AppDimens.height(15)),
    ),
  );
}
