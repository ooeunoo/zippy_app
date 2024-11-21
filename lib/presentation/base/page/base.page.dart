import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
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
    admobService.loadBottomBannerNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppSpacerV(value: AppDimens.height(10)),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppDimens.size(20)),
                      topLeft: Radius.circular(AppDimens.size(20)),
                    ),
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
                        tabItem(Assets.search, '', 1),
                        tabItem(Assets.user01, '', 2),
                      ],
                    ),
                  ),
                )),

            /// ///////////
            // native bannerAd
            // SizedBox(
            //   height: AppDimens.height(14),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         height: AppDimens.height(12),
            //         decoration: BoxDecoration(
            //           color: AppColor.graymodern800,
            //           borderRadius: BorderRadius.circular(AppDimens.size(12)),
            //         ),
            //         child: Center(
            //           child: Padding(
            //             padding: EdgeInsets.symmetric(
            //               horizontal: AppDimens.width(8),
            //             ),
            //             child: AppText("AD",
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .textXXS
            //                     .copyWith(color: AppColor.graymodern50)),
            //           ),
            //         ),
            //       ),
            //       AppSpacerH(value: AppDimens.width(4)),
            //       AppText("인천 소상공인 반값택시 지원 사업",
            //           style: Theme.of(context)
            //               .textTheme
            //               .textXS
            //               .copyWith(color: AppColor.graymodern100)),
            //     ],
            //   ),
            // ),
            //////////////////
            SizedBox(
              height: AppDimens.height(13),
              child: AdWidget(ad: admobService.bottomBannerAd.value!),
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
      icon: AppSvg(iconPath,
          color: controller.currentIndex.value == index
              ? AppColor.graymodern100
              : AppColor.graymodern600),
      label: label,
    );
  }
}
