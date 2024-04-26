import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSpacerV(
              value: AppDimens.height(150),
            ),
            sloganSection(context),
            logoSection(),
            const Spacer(),
            socialLoginGuide(context),
            AppSpacerV(value: AppDimens.height(30)),
            socialLoginSection(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget sloganSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppText("다양한 콘텐츠가 여기에,\n당신을 기다리고 있어요!",
            style: Theme.of(context).textTheme.displaySM.copyWith(
                color: AppColor.graymodern100, fontWeight: AppFontWeight.bold)),
      ],
    );
  }

  Widget logoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppSvg(Assets.logo, size: AppDimens.width(150)),
      ],
    );
  }

  Widget socialLoginGuide(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText("SNS 계정으로 간편 가입하기", style: Theme.of(context).textTheme.textSM)
      ],
    );
  }

  Widget socialLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            notifyAlreadyRegisteredUserEmail();
          },
          // onTap: controller.loginWithKakaoUser,
          child: CircleAvatar(
              backgroundColor: AppColor.kakaoBase,
              radius: AppDimens.size(30),
              child: const AppSvg(Assets.kakaoLogo)),
        ),
        const AppSpacerH(),
        GestureDetector(
          onTap: controller.loginWithNaverUser,
          child: CircleAvatar(
              backgroundColor: AppColor.naverBase,
              radius: AppDimens.size(30),
              child: const AppSvg(Assets.naverLogo)),
        )
      ],
    );
  }

  // Widget socialLoginButton() {

  // }
}
