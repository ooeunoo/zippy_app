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
import 'package:zippy/presentation/profile/binding/profile.binding.dart';
import 'package:zippy/presentation/profile/page/profile.page.dart';
import 'package:zippy/presentation/search/binding/search.binding.dart';
import 'package:zippy/presentation/search/page/search.page.dart';

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
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(AppDimens.size(20)),
                          topLeft: Radius.circular(AppDimens.size(20)),
                        ),
                        border: const Border(
                          top: BorderSide(
                            color: AppColor.graymodern900,
                          ),
                        ),
                      ),
                      height: AppDimens.height(80),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimens.size(20)),
                          topRight: Radius.circular(AppDimens.size(20)),
                        ),
                        child: BottomNavigationBar(
                          elevation: 1,
                          currentIndex: controller.currentIndex.value,
                          onTap: controller.changeTab,
                          selectedFontSize: 0,
                          unselectedFontSize: 0,
                          type: BottomNavigationBarType.fixed,
                          items: [
                            tabItem(Assets.home01, '', 0),
                            tabItem(Assets.search, '', 1),
                            tabItem(Assets.user01, '', 2),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Positioned(
              bottom: -12,
              left: 0,
              right: 0,
              child: _buildAdWidget(),
            ),
          ],
        ),
      ),
      body: Navigator(
        key: Get.nestedKey(1), // 중첩 네비게이션을 위한 키
        initialRoute: Routes.board,

        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.board:
              return GetPageRoute(
                routeName: Routes.board,
                page: () => const BoardPage(),
                binding: BoardBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
            case Routes.search:
              return GetPageRoute(
                routeName: Routes.search,
                page: () => const SearchPage(),
                binding: SearchBinding(),
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
                routeName: Routes.board,
                page: () => const BoardPage(),
                binding: BoardBinding(),
                transition: Transition.noTransition,
                gestureWidth: (context) => 0, // Disable swipe
              );
          }
        },
      ),
    );
  }

  BottomNavigationBarItem tabItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.only(bottom: 0), // 하단 패딩 제거
        height: 24, // 아이콘 컨테이너 높이 지정
        child: AppSvg(
          iconPath,
          color: controller.currentIndex.value == index
              ? AppColor.graymodern100
              : AppColor.graymodern600,
        ),
      ),
      label: label,
    );
  }

  Widget _buildAdWidget() {
    return Obx(() {
      final ad = admobService.bottomBannerAd.value;
      final isLoaded = admobService.isBottomBannerAdLoaded.value;

      if (ad == null || !isLoaded) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(10)),
        child: SizedBox(
          width: double.infinity,
          height: 32,
          child: Builder(
            builder: (context) {
              try {
                return AdWidget(ad: ad);
              } catch (e) {
                print('Error building AdWidget: $e');
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      );
    });
  }
}
