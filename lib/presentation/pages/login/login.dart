import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/font.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Login extends GetView<AuthController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSpacerV(
                value: AppDimens.height(100),
              ),
              AppSvg(Assets.logo, size: AppDimens.width(300)),
              // AppText("세상의 모든 콘텐츠를 내 손안에",
              //     style: Theme.of(context)
              //         .textTheme
              //         .displaySM
              //         .copyWith(color: AppColor.graymodern100)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.width(20),
                    vertical: AppDimens.height(60)),
                child: AppButton('카카오 로그인하기',
                    width: double.infinity,
                    height: AppDimens.height(60),
                    color: AppColor.kakaoBase,
                    titleStyle: Theme.of(context).textTheme.text2XL.copyWith(
                          color: AppColor.black,
                          fontWeight: AppFontWeight.bold,
                        ),
                    leadingIcon: const AppSvg(
                      Assets.kakaoLogo,
                    ), onPressed: () {
                  controller.loginKakaoUser();
                }),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
