import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppDivider extends StatelessWidget {
  final Color? color;
  final double? height;
  const AppDivider({super.key, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppColor.gray600,
      thickness: 1,
      height: height ?? AppDimens.size(1),
    );
  }
}
