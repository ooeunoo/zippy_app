import 'package:zippy/app/routes/app_pages.dart';
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

class BasePage extends GetView<BaseController> {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    // AdmobService admobService = Get.find();

    // admobService.loadBannerAd();

    return Scaffold(
      bottomNavigationBar: Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppDimens.size(20)),
                topLeft: Radius.circular(AppDimens.size(20))),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.size(20)),
              topRight: Radius.circular(AppDimens.size(20)),
            ),
            child: BottomNavigationBar(
              elevation: 1,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              items: [
                tabItem(Assets.home01, '', 0),
                tabItem(Assets.user01, '', 1),
              ],
            ),
          ))),
      body: Navigator(
        key: Get.nestedKey(1), // 중첩 네비게이션을 위한 키
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.board:
              return GetPageRoute(
                routeName: Routes.board,
                page: () => const BoardPage(),
                binding: BoardBinding(),
                transition: Transition.noTransition,
              );
            case Routes.profile:
              return GetPageRoute(
                routeName: Routes.profile,
                page: () => const ProfilePage(),
                binding: ProfileBinding(),
                transition: Transition.noTransition,
              );
            default:
              return GetPageRoute(
                routeName: Routes.board,
                page: () => const BoardPage(),
                binding: BoardBinding(),
                transition: Transition.noTransition,
              );
          }
        },
      ),
    );
  }

  BottomNavigationBarItem tabItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: AppSvg(iconPath,
          color: controller.currentIndex.value == index
              ? AppColor.graymodern100
              : AppColor.graymodern600),
      label: label,
    );
  }
}
