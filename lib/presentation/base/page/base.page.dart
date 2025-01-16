import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/presentation/base/controller/base.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/binding/board.binding.dart';
import 'package:zippy/presentation/board/page/board.page.dart';
import 'package:zippy/presentation/home/binding/home.binding.dart';
import 'package:zippy/presentation/home/page/home.page.dart';
import 'package:zippy/presentation/profile/binding/profile.binding.dart';
import 'package:zippy/presentation/profile/page/profile.page.dart';
import 'package:zippy/presentation/search/binding/search.binding.dart';
import 'package:zippy/presentation/search/page/search.page.dart';

double AD_HEIGHT = AppDimens.height(32);

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final BaseController controller = Get.find();
  final AdmobService admobService = Get.find();

  @override
  void initState() {
    super.initState();
    // Load ad after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      admobService.loadBottomBannerNativeAd();
    });
  }

  @override
  void dispose() {
    admobService.bottomBannerAd.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              elevation: 1,
              color: AppThemeColors.transparent(context),
              child: Container(
                height: kBottomNavigationBarHeight,
                decoration: BoxDecoration(
                  color: AppThemeColors.background(context),
                  border: Border(
                    top: BorderSide(
                      color: AppThemeColors.bottomNavigationBarBorder(context),
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.size(20)),
                    topRight: Radius.circular(AppDimens.size(20)),
                  ),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(Assets.home01, 0),
                          _buildNavItem(Assets.flexAlignRight, 1),
                          _buildNavItem(Assets.user01, 2),
                        ],
                      )),
                ),
              ),
            ),
            if (!isKeyboardVisible)
              Positioned(
                bottom: -20,
                left: 0,
                right: 0,
                child: _buildAdWidget(),
              ),
          ],
        ),
      ),
      body: Navigator(
        key: Get.nestedKey(1), // 중첩 네비게이션을 위한 키
        initialRoute: Routes.home,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.home:
              return GetPageRoute(
                routeName: Routes.home,
                page: () => const HomePage(),
                binding: HomeBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
            case Routes.board:
              return GetPageRoute(
                routeName: Routes.board,
                page: () => const BoardPage(),
                binding: BoardBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
            case Routes.profile:
              return GetPageRoute(
                routeName: Routes.profile,
                page: () => const ProfilePage(),
                binding: ProfileBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
            default:
              return GetPageRoute(
                routeName: Routes.home,
                page: () => const HomePage(),
                binding: HomeBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
          }
        },
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
        child: Center(
          child: SizedBox(
            height: AppDimens.height(24),
            child: AppSvg(
              iconPath,
              color: controller.currentIndex.value == index
                  ? AppThemeColors.bottomNavigationBarSelectedItem(context)
                  : AppThemeColors.bottomNavigationBarUnselectedItem(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdWidget() {
    return Obx(() {
      final ad = admobService.bottomBannerAd.value;
      final isLoaded = admobService.isBottomBannerAdLoaded.value;

      if (ad == null || !isLoaded) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.width(0)),
          child: SizedBox(
            width: double.infinity,
            height: AD_HEIGHT,
            child: Builder(
              builder: (context) {
                try {
                  return AdWidget(
                      key: ValueKey('ad_widget_${ad.hashCode}'), ad: ad);
                } catch (e) {
                  print('Error building AdWidget: $e');
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
