import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColor.gray600,
      thickness: 1,
      height: AppDimens.size(1),
    );
  }
}
