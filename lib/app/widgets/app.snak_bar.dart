import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int SNACKBAR_DURATION = 1;
notifyNoItems() {
  Get.rawSnackbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // AppSvg(Assets.check),
        AppSpacerH(value: AppDimens.size(10)),
        AppText(
          '우측으로 이동해주세요',
          align: TextAlign.center,
          style: Theme.of(Get.context!).textTheme.textMD.copyWith(
                color: AppColor.gray900,
                fontWeight: AppFontWeight.regular,
              ),
        ),
      ],
    ),
    forwardAnimationCurve: Curves.ease,
    maxWidth: AppDimens.size(230),
    backgroundColor: AppColor.brand500,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: AppDimens.size(16),
    duration: Duration(seconds: SNACKBAR_DURATION),
    animationDuration: const Duration(milliseconds: 1000), // 애니메이션 시간을 조정합니다.
    padding: EdgeInsets.symmetric(
      horizontal: AppDimens.width(20),
      vertical: AppDimens.height(12),
    ),
    margin: EdgeInsets.symmetric(
      vertical:
          MediaQuery.of(Get.context!).padding.bottom + AppDimens.height(20),
      horizontal: AppDimens.width(20),
    ),
  );
}
