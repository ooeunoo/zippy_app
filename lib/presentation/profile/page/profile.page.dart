import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_menu.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/menu.model.dart';
import 'package:zippy/presentation/profile/controller/profile.controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
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
                  _buildAppLogo(context),
                  _buildAvatarInfo(context),
                  const AppSpacerV(),
                  _buildMenu(context)
                ],
              ),
              // 로그아웃 버튼 추가
              Positioned(
                bottom: AppDimens.height(20),
                left: 0,
                right: 0,
                child: AppButton(
                  "테스트",
                  onPressed: () {
                    notifyLogout();
                  },
                ),
              ),
              Obx(() {
                if (authService.isLoggedIn.value) {
                  return Positioned(
                    bottom: AppDimens.height(20),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _buildLogoutButton(context, authService.logout),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo(BuildContext context) {
    return AppSvg(
      Assets.logo,
      size: AppDimens.size(80),
    );
  }

  Widget _buildAvatarInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppDimens.size(80),
              width: AppDimens.size(80),
              child: RandomAvatar(
                  Get.find<AuthService>()
                          .currentUser
                          .value
                          ?.avatarIndex
                          ?.toString() ??
                      '0',
                  trBackground: true),
            )
          ],
        ),
        const AppSpacerV(),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
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

  Widget _buildLogoutButton(BuildContext context, VoidCallback logout) {
    return AppButton(
      '로그아웃',
      color: AppColor.transparent,
      titleStyle: Theme.of(context).textTheme.textSM.copyWith(
          color: AppColor.graymodern600,
          decoration: TextDecoration.underline,
          decorationColor: AppColor.graymodern600),
      borderColor: AppColor.transparent,
      onPressed: () {
        logout();
        notifyLogout();
      },
    );
  }
}
