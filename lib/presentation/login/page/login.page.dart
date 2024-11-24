import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/login/controller/login.controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasPreviousRoute = Get.routing.route?.isFirst == false;

    return Scaffold(
      appBar: AppHeader(
        backgroundColor: AppColor.transparent,
        leading: hasPreviousRoute
            ? IconButton(
                padding: EdgeInsets.only(left: AppDimens.size(20)),
                icon: const Icon(Icons.close, color: AppColor.gray50),
                onPressed: () => Get.back(),
                splashRadius: 24,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              )
            : null,
        automaticallyImplyLeading: hasPreviousRoute,
        title: const SizedBox.shrink(),
        actions: hasPreviousRoute
            ? null
            : [
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
                    onPressed: () => Get.offAllNamed(Routes.base),
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
                    borderColor: AppColor.transparent,
                    titleStyle: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.black,
                          fontWeight: AppFontWeight.semibold,
                        ),
                    onPressed: () => controller.onClickLoginInWithKakao(),
                    leadingIcon: AppSvg(Assets.kakao, size: AppDimens.size(18)),
                    color: AppColor.kakaoBackground,
                  ),
                  AppSpacerV(value: AppDimens.height(12)),
                  // 구글 로그인 버튼
                  AppButton(
                    '구글로 시작하기',
                    borderColor: AppColor.transparent,
                    titleStyle: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.black,
                          fontWeight: AppFontWeight.semibold,
                        ),
                    onPressed: () => controller.onClickLoginInWithGoogle(),
                    leadingIcon:
                        AppSvg(Assets.google, size: AppDimens.size(18)),
                    color: AppColor.white,
                  ),
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
