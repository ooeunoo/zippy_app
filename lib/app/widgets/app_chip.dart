import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_text.dart';

class AppChip extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final Color? borderColor;

  const AppChip({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.zero,
      backgroundColor: color ?? AppColor.brand50,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.width(16)),
        side: BorderSide(
            width: 1, // 테두리 두께
            color: borderColor ?? AppColor.brand200),
      ),
      label: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppDimens.width(10), vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(text,
                align: TextAlign.center,
                style: textStyle ??
                    Theme.of(context).textTheme.textSM.copyWith(
                          color: AppColor.brand700,
                        )),
          ],
        ),
      ),
    );
  }
}
