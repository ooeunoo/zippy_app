import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/app/widgets/app_snak_bar.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_menu.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_text_input.dart';
import 'package:zippy/domain/enum/oauth_provider._type.enum.dart';
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
          _buildMainContent(context, authService, webViewService),
          _buildLogoutButtonWrapper(authService),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AuthService authService,
      WebViewService webViewService) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAppLogo(context),
        Obx(() {
          if (authService.isLoggedIn.value) {
            return Column(
              children: [
                _buildUserInfo(context, authService),
                const AppSpacerV(),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
        _buildMenu(context, webViewService),
      ],
    );
  }

  Widget _buildAppLogo(BuildContext context) {
    return AppSvg(
      Assets.logo,
      size: AppDimens.size(120),
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthService authService) {
    final baseColor = AppThemeColors.boardCardBaseColor(context);
    final baseColor2 =
        AppThemeColors.boardCardBaseColor(context).withOpacity(0.2);

    return Obx(() {
      final user = authService.currentUser.value;
      final provider = user?.provider;
      final email = user?.email ?? '';

      return Container(
        width: double.infinity, // 전체 너비 사용
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.size(16),
          vertical: AppDimens.size(12),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              baseColor2,
              baseColor,
              baseColor2,
              baseColor,
              baseColor2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radius(12)),
          border: Border.all(
            color: AppThemeColors.articleItemBoxBorderColor(context),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildProviderIcon(context, provider),
            AppSpacerH(value: AppDimens.width(12)),
            Expanded(
              child: AppText(
                email,
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppThemeColors.textHighest(context),
                      fontWeight: AppFontWeight.regular,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProviderIcon(BuildContext context, OAuthProviderType? provider) {
    return Container(
      padding: EdgeInsets.all(AppDimens.size(8)),
      decoration: BoxDecoration(
        color: _getProviderBackground(provider),
        shape: BoxShape.circle,
      ),
      child: AppSvg(
        provider?.image ?? '',
        size: AppDimens.size(18),
        color: _getProviderIconColor(provider),
      ),
    );
  }

  Color _getProviderBackground(OAuthProviderType? provider) {
    switch (provider) {
      case OAuthProviderType.APPLE:
        return AppColor.black;
      case OAuthProviderType.GOOGLE:
        return AppColor.white;
      case OAuthProviderType.KAKAO:
        return AppColor.kakaoBackground;
      default:
        return AppColor.graymodern800;
    }
  }

  Color? _getProviderIconColor(OAuthProviderType? provider) {
    switch (provider) {
      case OAuthProviderType.APPLE:
        return AppColor.white;
      case OAuthProviderType.GOOGLE:
        return null; // Original colors
      case OAuthProviderType.KAKAO:
        return AppColor.black;
      default:
        return AppColor.graymodern100;
    }
  }

  Widget _buildMenu(BuildContext context, WebViewService webViewService) {
    final List<MenuSection> menu = [
      _buildMySection(),
      _buildSettingsSection(),
      _buildSupportSection(webViewService),
    ];

    return AppMenu(menu: menu, backgroundColor: AppColor.gray100);
  }

  MenuSection _buildMySection() {
    return MenuSection(
      section: 'My',
      items: [
        // MenuItem(
        //   icon: Assets.sliders04,
        //   title: '구독 관리',
        //   onTap: () {
        //     controller.onClickSubscriptionManagement();
        //   },
        // ),
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

  MenuSection _buildSettingsSection() {
    return MenuSection(
      section: '설정',
      items: [
        MenuItem(
          icon: Assets.bellRinging02,
          title: '뉴스 알리미',
          onTap: () {
            controller.onClickKeywordNotification();
          },
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showAppDialog(
      '의견 보내기',
      message: '다양한 의견을 남겨주세요',
      child: Column(
        children: [
          AppTextInput(
            controller: feedbackController,
            inputType: TextInputType.multiline,
            maxLines: 5,
          ),
        ],
      ),
      onConfirm: () {
        controller.onHandleCreateFeedback(feedbackController.text);
        notifyFeedbackSuccess();
      },
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
            _showFeedbackDialog(Get.context!);
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
            color: AppThemeColors.textLow(context),
            decoration: TextDecoration.underline,
            decorationColor: AppThemeColors.textLow(context),
          ),
      borderColor: AppColor.transparent,
      onPressed: () {
        logout();
        notifyLogout();
      },
    );
  }
}
