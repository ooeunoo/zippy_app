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

class BottomSupportMenu extends StatelessWidget {
  final Article article;
  final Function() share;
  final Function() report;
  final Function() originalArticle;
  final Function() bookmark;
  final bool isBookmarked;

  const BottomSupportMenu({
    super.key,
    required this.article,
    required this.share,
    required this.report,
    required this.originalArticle,
    required this.bookmark,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(context, "원문 보기", Icons.web, AppColor.graymodern300,
              originalArticle),
          const AppDivider(),
          _buildMenuItem(
              context,
              "북마크하기",
              Icons.bookmark,
              isBookmarked ? AppColor.brand600 : AppColor.graymodern300,
              bookmark),
          const AppDivider(),
          _buildMenuItem(
              context, "공유하기", Icons.share, AppColor.graymodern300, share),
          const AppDivider(),
          _buildMenuItem(
              context, "신고하기", Icons.report, AppColor.graymodern300, report),
          AppSpacerV(
            value: AppDimens.height(30),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon,
      Color? color, GestureTapCallback action) {
    return InkWell(
      onTap: () {
        Get.back();
        Future.delayed(const Duration(milliseconds: 100), () {
          action();
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            children: [
              SizedBox(width: AppDimens.width(24)),
              Icon(
                icon,
                color: color,
                size: AppDimens.size(20),
              ),
              AppSpacerH(value: AppDimens.width(12)),
              AppText(title,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                        color: AppColor.graymodern100,
                      )),
              const Spacer(),
            ],
          )),
    );
  }
}
