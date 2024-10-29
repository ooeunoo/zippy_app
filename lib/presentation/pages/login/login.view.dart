import 'package:flutter/material.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/controllers/auth/auth.controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: AppButton(
              '둘러보기',
              width: AppDimens.width(70),
              color: AppColor.transparent,
              borderColor: AppColor.transparent,
              titleStyle: Theme.of(context).textTheme.display2XL.copyWith(
                    color: AppColor.white,
                    fontWeight: AppFontWeight.semibold,
                  ),
              onPressed: () => Get.previousRoute.isNotEmpty
                  ? Get.back()
                  : Get.offAllNamed(Routes.base),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // 로고
              Center(
                child: AppSvg(Assets.logo, size: AppDimens.size(200)),
              ),
              const Spacer(flex: 2),
              // 로그인 버튼들
              Column(
                children: [
                  // 카카오 로그인 버튼
                  AppButton(
                    '카카오로 시작하기',
                    titleStyle: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.black,
                          fontWeight: AppFontWeight.semibold,
                        ),
                    onPressed: () {
                      // 카카오 로그인 구현
                    },
                    leadingIcon: AppSvg(Assets.kakao, size: AppDimens.size(18)),
                    color: AppColor.kakaoBackground,
                  ),
                  AppSpacerV(value: AppDimens.height(12)),
                  // 구글 로그인 버튼
                ],
              ),
              AppSpacerV(value: AppDimens.height(40)),
            ],
          ),
        ),
      ),
    );
  }
}
