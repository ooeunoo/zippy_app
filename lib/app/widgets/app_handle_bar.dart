import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppHandleBar extends StatelessWidget {
  final Color color;
  const AppHandleBar({super.key, this.color = AppColor.gray300});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.width(40),
      height: AppDimens.height(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.width(5)),
      ),
    );
  }
}
