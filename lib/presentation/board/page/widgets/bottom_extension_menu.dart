import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class BottomExtensionMenu extends StatelessWidget {
  final Article article;
  final Function() share;
  final Function() report;
  final Function() openOriginalArticle;

  const BottomExtensionMenu({
    super.key,
    required this.article,
    required this.share,
    required this.report,
    required this.openOriginalArticle,
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
          _buildMenuItem(context, "원문 기사 보기", Icons.web, openOriginalArticle),
          const AppDivider(),
          _buildMenuItem(context, "공유하기", Icons.share, share),
          const AppDivider(),
          _buildMenuItem(context, "신고하기", Icons.report, report),
          AppSpacerV(
            value: AppDimens.height(30),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon,
      GestureTapCallback action) {
    return InkWell(
      onTap: () {
        action();
        Get.back();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColor.graymodern300,
                size: AppDimens.size(20),
              ),
              const AppSpacerH(),
              AppText(title,
                  style: Theme.of(context).textTheme.textLG.copyWith(
                      color: AppColor.graymodern100,
                      fontWeight: AppFontWeight.regular)),
              AppSpacerH(value: AppDimens.width(10)),
            ],
          )),
    );
  }
}
