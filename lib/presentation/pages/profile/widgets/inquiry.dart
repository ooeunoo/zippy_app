import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_webview.dart';

class InquryView extends StatelessWidget {
  const InquryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: const AppWebview(uri: Constants.inquryUrl));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Container(),
      leadingWidth: AppDimens.width(5),
      title: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: AppColor.white,
            ),
          ),
          AppSpacerH(value: AppDimens.size(5)),
          AppText(
            "의견 보내기",
            style: Theme.of(context)
                .textTheme
                .textLG
                .copyWith(color: AppColor.gray100),
          ),
        ],
      ),
      // bottom: tabBar()
    );
  }
}
