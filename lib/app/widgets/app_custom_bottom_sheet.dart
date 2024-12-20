import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_handle_bar.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

void openCustomBottomSheet(
  Widget child, {
  String? title,
  EdgeInsets? padding,
  bool isDismissible = true,
  double? height,
}) {
  Get.bottomSheet(
    AppCustomBottomSheet(
      child: child,
      title: title,
      padding: padding,
      height: height,
    ),
    isDismissible: isDismissible,
    isScrollControlled: true,
    enableDrag: true,
  );
}

class AppCustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;

  const AppCustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                AppSpacerV(value: AppDimens.height(10)),
                const AppHandleBar(),

                // Title (if provided)
                if (title != null) ...[
                  AppSpacerV(value: AppDimens.height(20)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            title!,
                            style: Theme.of(context).textTheme.textXL.copyWith(
                                  color: AppColor.gray900,
                                  fontWeight: AppFontWeight.semibold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacerV(value: AppDimens.height(20)),
                ],
              ],
            ),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: padding ??
                      EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
