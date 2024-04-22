import 'package:cocomu/app/utils/assets.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/app/widgets/app_svg.dart';
import 'package:cocomu/presentation/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Base extends GetView<BaseController> {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Obx(() => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BottomNavigationBar(
                elevation: 1,
                currentIndex: controller.currentPage.value,
                onTap: controller.goToTab,
                items: [
                  tabItem(Assets.home01, '', 0),
                  tabItem(Assets.search, '', 1),
                  tabItem(Assets.user01, '', 2),
                ],
              ),
            ))),
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [...controller.pages],
        ));
  }

  BottomNavigationBarItem tabItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: AppSvg(iconPath,
          color: controller.currentPage.value == index
              ? AppColor.graymodern100
              : AppColor.graymodern600),
      label: label,
    );
  }
}
