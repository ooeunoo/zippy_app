import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        fontFamily: 'Suit',
        useMaterial3: true,
        highlightColor: Colors.transparent,
        splashColor: const Color.fromRGBO(0, 0, 0, 0),
        scaffoldBackgroundColor: AppColor.graymodern50,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.graymodern50,
            surfaceTintColor: AppColor.graymodern50),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColor.graymodern50,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(
                size: AppDimens.width(24), color: AppColor.gray900),
            unselectedIconTheme: IconThemeData(
                size: AppDimens.width(24), color: AppColor.gray500),
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

  static ThemeData darkTheme(BuildContext context) => ThemeData(
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
            selectedIconTheme: IconThemeData(
                size: AppDimens.width(24), color: AppColor.gray900),
            unselectedIconTheme: IconThemeData(
                size: AppDimens.width(24), color: AppColor.gray500),
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
}

extension CustomTextStyles on TextTheme {
  TextStyle get text2XL => TextStyle(
        fontSize: 23.sp,
      );

  TextStyle get textXL => TextStyle(
        fontSize: 21.sp,
      );

  TextStyle get textLG => TextStyle(
        fontSize: 19.sp,
      );

  TextStyle get textMD => TextStyle(
        fontSize: 17.sp,
      );

  TextStyle get textSM => TextStyle(
        fontSize: 15.sp,
      );

  TextStyle get textXS => TextStyle(
        fontSize: 13.sp,
      );

  TextStyle get textXXS => TextStyle(
        fontSize: 11.sp,
      );
}
