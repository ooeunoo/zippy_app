import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/content.dart';

class BottomDropMenu extends StatelessWidget {
  final Content content;
  final Function() share;
  final Function() report;

  const BottomDropMenu({
    super.key,
    required this.content,
    required this.share,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColor.graymodern950,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(context, "공유하기", share),
          const AppDivider(),
          _buildMenuItem(context, "신고하기", report),
          AppSpacerV(
            value: AppDimens.height(30),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, GestureTapCallback action) {
    return InkWell(
      onTap: () {
        action();
        Get.back();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: AppText(title,
              style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.graymodern100,
                  fontWeight: AppFontWeight.regular))),
    );
  }
}
