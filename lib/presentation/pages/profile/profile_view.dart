import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/random.dart';
import 'package:zippy/app/widgets/app_menu.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/menu.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';
import 'package:zippy/presentation/pages/profile/widgets/privacy.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: appBar(context),
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20), vertical: AppDimens.height(0)),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appLogo(context),
                avatarInfo(context),
                const AppSpacerV(),
                menu(context)
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: logout(context))
          ],
        ),
      ),
    ));
  }

  Widget appLogo(BuildContext context) {
    return AppSvg(
      Assets.logo,
      size: AppDimens.size(80),
    );
  }

  Widget logout(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.logoutUser();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.height(10)),
        child: AppText(
          "로그아웃",
          style: Theme.of(context).textTheme.textSM.copyWith(
                decoration: TextDecoration.underline,
                color: AppColor.graymodern500,
                decorationColor: AppColor.graymodern500,
              ),
        ),
      ),
    );
  }

  Widget avatarInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppDimens.size(80),
              width: AppDimens.size(80),
              child: RandomAvatar(
                  controller.user.value?.email ?? randomInt(0, 10).toString(),
                  trBackground: true),
            )
          ],
        ),
        const AppSpacerV(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => AppText(controller.user.value?.email ?? "",
                style: Theme.of(context)
                    .textTheme
                    .textMD
                    .copyWith(color: AppColor.graymodern100)))
          ],
        )
      ],
    );
  }

  Widget menu(BuildContext context) {
    List<MenuSection> menu = [
      MenuSection(
        section: 'My',
        items: [
          MenuItem(
              icon: Assets.sliders04,
              title: '구독 채널 관리',
              onTap: () {
                Get.toNamed(
                  Routes.channel,
                );
              }),
          MenuItem(
              icon: Assets.bookmarkLine,
              title: '저장한 콘텐츠',
              onTap: () {
                Get.toNamed(
                  Routes.bookmark,
                );
              })
        ],
      ),
      MenuSection(section: '고객지원 및 정보', items: [
        MenuItem(icon: Assets.file06, title: '개발자 문의하기', onTap: () {}),
        MenuItem(
            icon: Assets.file02,
            title: '개인정보처리방침',
            onTap: () {
              Get.to(() => const PrivacyView(),
                  transition: Transition.rightToLeft);
            }),
      ])
    ];

    return AppMenu(menu: menu, backgroundColor: AppColor.gray100);
  }
}
