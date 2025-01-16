import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final homeController = Get.find<HomeController>();
    return AppHeader(
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
        child: AppSvg(Assets.logo, size: AppDimens.width(60)),
      ),
      title: const SizedBox.shrink(),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: AppDimens.width(8)),
      //     child: IconButton(
      //       onPressed: () => homeController.onHandleGoToSearchView(null),
      //       icon: Icon(Icons.search, color: AppThemeColors.iconColor(context)),
      //     ),
      //   ),
      // ],
    );
  }
}
