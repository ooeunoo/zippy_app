import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

/// Light theme
ThemeData themeLight(BuildContext context) => ThemeData(
      fontFamily: 'Suit',
      useMaterial3: true,
      highlightColor: Colors.transparent,
      splashColor: const Color.fromRGBO(0, 0, 0, 0),
      scaffoldBackgroundColor: AppColor.graymodern950,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.graymodern950,
          surfaceTintColor: AppColor.graymodern950),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColor.graymodern950,
          type: BottomNavigationBarType.fixed,
          selectedIconTheme:
              IconThemeData(size: AppDimens.width(24), color: AppColor.gray900),
          unselectedIconTheme:
              IconThemeData(size: AppDimens.width(24), color: AppColor.gray500),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: Theme.of(context)
              .textTheme
              .textXS
              .copyWith(color: AppColor.gray900),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .textXS
              .copyWith(color: AppColor.gray500)),
    );

/// Dark theme
ThemeData themeDark(BuildContext context) => ThemeData(
      fontFamily: 'Suit',
      useMaterial3: true,
      highlightColor: Colors.transparent,
      splashColor: const Color.fromRGBO(0, 0, 0, 0),
      scaffoldBackgroundColor: AppColor.black,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.black, surfaceTintColor: AppColor.black),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColor.black,
          type: BottomNavigationBarType.fixed,
          selectedIconTheme:
              IconThemeData(size: AppDimens.width(24), color: AppColor.gray900),
          unselectedIconTheme:
              IconThemeData(size: AppDimens.width(24), color: AppColor.gray500),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: Theme.of(context)
              .textTheme
              .textXS
              .copyWith(color: AppColor.gray900),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .textXS
              .copyWith(color: AppColor.gray500)),
    );

extension CustomTextStyles on TextTheme {
  TextStyle get display2XL => TextStyle(fontSize: 72.sp);
  TextStyle get displayXL => TextStyle(fontSize: 60.sp);
  TextStyle get displayLG => TextStyle(fontSize: 48.sp);
  TextStyle get displayMD => TextStyle(fontSize: 36.sp);
  TextStyle get displaySM => TextStyle(fontSize: 30.sp);
  TextStyle get displayXS => TextStyle(fontSize: 24.sp);
  TextStyle get text2XL =>
      (TextStyle(fontSize: 22.sp, color: AppColor.gray900));
  TextStyle get textXL => (TextStyle(fontSize: 21.sp, color: AppColor.gray900));
  TextStyle get textLG => TextStyle(fontSize: 19.sp, color: AppColor.gray800);
  TextStyle get textMD => TextStyle(fontSize: 17.sp, color: AppColor.gray700);
  TextStyle get textSM => TextStyle(fontSize: 15.sp, color: AppColor.gray600);
  TextStyle get textXS => TextStyle(fontSize: 13.sp, color: AppColor.gray500);
  TextStyle get textXXS => TextStyle(fontSize: 11.sp, color: AppColor.gray500);
}
