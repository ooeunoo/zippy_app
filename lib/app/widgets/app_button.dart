import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;
  final bool disable;

  final Widget? leadingIcon;

  final VoidCallback onPressed;

  const AppButton(this.title,
      {super.key,
      required this.onPressed,
      this.titleStyle,
      this.color,
      this.borderColor,
      this.leadingIcon,
      this.width,
      this.height,
      this.disable = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? AppDimens.size(48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.size(8)),
      ),
      child: TextButton(
        onPressed: () {
          if (!disable) {
            onPressed();
          }
        },
        style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: color != null
                ? WidgetStateProperty.all(color)
                : disable
                    ? WidgetStateProperty.all(
                        AppThemeColors.buttonDisableBackgroundColor(context))
                    : WidgetStateProperty.all(
                        AppThemeColors.buttonBackgroundColor(context)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.size(8)),
                side: BorderSide(
                    color: borderSideColorWrap(context),
                    width: AppDimens.width(1))))),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leadingIcon!,
                    AppSpacerH(value: AppDimens.width(10)),
                  ],
                ),
              AppText(title, style: titleStyleWrap(context))
            ],
          ),
        ),
      ),
    );
  }

  Color borderSideColorWrap(BuildContext context) {
    Color color = borderColor ?? AppThemeColors.buttonBorderColor(context);
    if (disable) {
      color = AppThemeColors.buttonDisableBorderColor(context);
    }
    return color;
  }

  TextStyle titleStyleWrap(BuildContext context) {
    TextStyle style = titleStyle ??
        Theme.of(context).textTheme.textSM.copyWith(
            fontWeight: AppFontWeight.semibold,
            color: AppThemeColors.textHigh(context));

    if (disable) {
      style =
          style.copyWith(color: AppThemeColors.buttonDisableTextColor(context));
    }

    return style;
  }
}
