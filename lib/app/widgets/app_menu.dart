import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMenu extends StatelessWidget {
  final List<Map<String, dynamic>> menu;
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
          final section = menu[index]['section'] as String;
          final items = (menu[index]['items'] as List<dynamic>)
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

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final icon = item['icon'] as String;
    final title = item['title'] as String;
    final onTap = item['onTap'] as void Function();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(10), vertical: AppDimens.height(12)),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            AppSvg(
              icon,
              size: AppDimens.size(20),
              color: AppColor.graymodern400,
            ),
            AppSpacerH(value: AppDimens.width(10)),
            AppText(title,
                style: Theme.of(context)
                    .textTheme
                    .textLG
                    .copyWith(color: AppColor.graymodern100)),
          ],
        ),
      ),
    );
  }
}
