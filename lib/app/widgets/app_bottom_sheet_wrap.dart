import 'package:flutter/material.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/widgets/app_handle_bar.dart';

class AppBottomSheetWrap extends StatelessWidget {
  final Widget child;
  const AppBottomSheetWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(40)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(AppDimens.width(20))),
          border: Border(
            top: BorderSide(color: AppColor.gray200, width: AppDimens.width(1)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(AppDimens.width(10)),
                child: const AppHandleBar(),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
