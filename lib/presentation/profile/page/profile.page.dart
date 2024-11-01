import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/random.dart';
import 'package:zippy/app/widgets/app_menu.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/menu.model.dart';
import 'package:zippy/presentation/profile/controller/profile.controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
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
              // 로그아웃 버튼 추가
              Positioned(
                bottom: AppDimens.height(20),
                left: 0,
                right: 0,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // 로그아웃 로직 추가
                      controller.onClickLogout();
                    },
                    child: AppText(
                      '로그아웃',
                      style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppColor.gray600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.gray600,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appLogo(BuildContext context) {
    return AppSvg(
      Assets.logo,
      size: AppDimens.size(80),
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
                  controller.user?.avatarIndex?.toString() ?? '0',
                  trBackground: true),
            )
          ],
        ),
        const AppSpacerV(),
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
              title: '구독 관리',
              onTap: () {
                controller.onClickSubscriptionManagement();
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
        MenuItem(
            icon: Assets.message,
            title: '리뷰 남기기',
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
            }),
        MenuItem(
            icon: Assets.file06,
            title: '의견 보내기',
            onTap: () {
              // Get.to(
              //     () => const AppWebview(
              //         title: '의견 보내기', uri: Constants.inquriyUrl),
              //     transition: Transition.rightToLeftWithFade);
            }),
      ]),
    ];

    return AppMenu(menu: menu, backgroundColor: AppColor.gray100);
  }
}
