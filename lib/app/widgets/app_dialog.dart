import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';

showAppDialog(
  String title, {
  String? message,
  String confirmText = '확인',
  String cancelText = '취소',
  Color confirmButtonColor = AppColor.brand600,
  Color confirmTextColor = AppColor.white,
  Widget? child,
  bool barrierDismissible = true,
  bool onlyConfirm = false,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  Get.dialog<bool>(
    AppDialog(
      title: title,
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmButtonColor: confirmButtonColor,
      confirmTextColor: confirmTextColor,
      barrierDismissible: barrierDismissible,
      onlyConfirm: onlyConfirm,
      child: child,
    ),
    barrierDismissible: barrierDismissible,
  );
}

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color confirmButtonColor;
  final Color confirmTextColor;
  final Widget? child;
  final bool barrierDismissible;
  final bool onlyConfirm;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    required this.confirmButtonColor,
    required this.confirmTextColor,
    this.child,
    this.barrierDismissible = true,
    this.onlyConfirm = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.size(16)),
        ),
        elevation: 0,
        child: contentBox(context),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.size(20)),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColor.graymodern950,
        borderRadius: BorderRadius.circular(AppDimens.size(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.gray50,
                  fontWeight: AppFontWeight.semibold,
                ),
          ),
          AppSpacerV(value: AppDimens.height(15)),
          if (message != null) ...[
            Text(
              message!,
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.gray50,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (child != null) ...[
            AppSpacerV(value: AppDimens.height(15)),
            child!,
          ],
          AppSpacerV(value: AppDimens.height(22)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (!onlyConfirm) ...[
                Expanded(
                  child: AppButton(
                    cancelText,
                    onPressed: () {
                      Navigator.of(Get.overlayContext!, rootNavigator: true)
                          .pop();
                      if (onCancel != null) {
                        onCancel!();
                      }
                    },
                    color: AppColor.transparent,
                    borderColor: AppColor.transparent,
                    titleStyle: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.gray50,
                        ),
                  ),
                ),
                AppSpacerH(value: AppDimens.width(10)),
              ],
              Expanded(
                child: AppButton(
                  confirmText,
                  onPressed: () {
                    Navigator.of(Get.overlayContext!, rootNavigator: true)
                        .pop();
                    onConfirm();
                  },
                  color: confirmButtonColor,
                  titleStyle: Theme.of(context).textTheme.textMD.copyWith(
                        color: confirmTextColor,
                        fontWeight: AppFontWeight.semibold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
