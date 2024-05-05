import 'package:flutter/widgets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/menu.dart';

class AppMenu extends StatelessWidget {
  final List<MenuSection> menu;
  final Color backgroundColor;

  const AppMenu({
    super.key,
    required this.menu,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menu.length,
        itemBuilder: (BuildContext context, int index) {
          final section = menu[index].section;
          final items = menu[index]
              .items
              .map<Widget>((item) => _buildMenuItem(context, item))
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(context, section),
              ...items,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String sectionTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.height(5)),
      child: AppText(sectionTitle,
          style: Theme.of(context)
              .textTheme
              .textSM
              .copyWith(color: AppColor.graymodern500)),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    final icon = item.icon;
    final title = item.title;
    final onTap = item.onTap;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(10), vertical: AppDimens.height(12)),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            AppSvg(
              icon,
              size: AppDimens.size(20),
              color: AppColor.graymodern400,
            ),
            AppSpacerH(value: AppDimens.width(10)),
            Expanded(
              child: AppText(title,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .textLG
                      .copyWith(color: AppColor.graymodern100)),
            ),
          ],
        ),
      ),
    );
  }
}
