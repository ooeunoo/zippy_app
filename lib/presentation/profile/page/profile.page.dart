import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_menu.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/domain/model/menu.model.dart';
import 'package:zippy/presentation/profile/controller/profile.controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final webViewService = Get.find<WebViewService>();

    return Scaffold(
      body: SafeArea(
        child: _buildBody(context, authService, webViewService),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthService authService,
      WebViewService webViewService) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      child: Stack(
        children: [
          _buildMainContent(context, webViewService),
          _buildLogoutButtonWrapper(authService),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, WebViewService webViewService) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAppLogo(context),
        _buildAvatarInfo(context),
        const AppSpacerV(),
        _buildMenu(context, webViewService),
      ],
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
                trBackground: true,
              ),
            )
          ],
        ),
        const AppSpacerV(),
      ],
    );
  }

  Widget _buildMenu(BuildContext context, WebViewService webViewService) {
    final List<MenuSection> menu = [
      _buildMySection(),
      _buildSupportSection(webViewService),
    ];

    return AppMenu(menu: menu, backgroundColor: AppColor.gray100);
  }

  MenuSection _buildMySection() {
    return MenuSection(
      section: 'My',
      items: [
        MenuItem(
          icon: Assets.sliders04,
          title: '구독 관리',
          onTap: () {
            controller.onClickSubscriptionManagement();
          },
        ),
        MenuItem(
          icon: Assets.bookmarkLine,
          title: '저장한 콘텐츠',
          onTap: () {
            controller.onClickBookmark();
          },
        ),
      ],
    );
  }

  MenuSection _buildSupportSection(WebViewService webViewService) {
    return MenuSection(
      section: '고객지원 및 정보',
      items: [
        MenuItem(
          icon: Assets.message,
          title: '리뷰 남기기',
          onTap: () async {
            final InAppReview inAppReview = InAppReview.instance;
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          },
        ),
        MenuItem(
          icon: Assets.file06,
          title: '의견 보내기',
          onTap: () {
            webViewService.showWebView(Constants.inquriyUrl);
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButtonWrapper(AuthService authService) {
    return Obx(() {
      if (authService.isLoggedIn.value) {
        return Positioned(
          bottom: AppDimens.height(20),
          left: 0,
          right: 0,
          child: Center(
            child: _buildLogoutButton(Get.context!, authService.logout),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildLogoutButton(BuildContext context, VoidCallback logout) {
    return AppButton(
      '로그아웃',
      color: AppColor.transparent,
      titleStyle: Theme.of(context).textTheme.textSM.copyWith(
            color: AppColor.graymodern600,
            decoration: TextDecoration.underline,
            decorationColor: AppColor.graymodern600,
          ),
      borderColor: AppColor.transparent,
      onPressed: () {
        logout();
        notifyLogout();
      },
    );
  }
}
