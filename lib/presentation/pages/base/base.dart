import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Base extends GetView<BaseController> {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
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
                currentIndex: controller.currentPage.value,
                onTap: controller.goToTab,
                items: [
                  tabItem(Assets.home01, '', 0),
                  tabItem(Assets.user01, '', 1),
                ],
              ),
            ))),
        body: Obx(() => IndexedStack(
              index: controller.currentPage.value,
              children: [...controller.pages],
            )));
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
