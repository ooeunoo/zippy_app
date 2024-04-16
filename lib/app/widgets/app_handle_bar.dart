import 'package:flutter/material.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';

class AppHandleBar extends StatelessWidget {
  const AppHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.width(40),
      height: AppDimens.height(4),
      decoration: BoxDecoration(
        color: AppColor.gray300,
        borderRadius: BorderRadius.circular(AppDimens.width(5)),
      ),
    );
  }
}
