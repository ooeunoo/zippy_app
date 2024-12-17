import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zippy/app/styles/color.dart';

class AppTheme {
  // static ThemeData lightTheme(BuildContext context) => ThemeData(
  //       fontFamily: 'Suit',
  //       useMaterial3: true,
  //       highlightColor: AppColor.transparent,
  //       splashColor: AppColor.transparent,
  //       scaffoldBackgroundColor: AppColor.graymodern50,
  //       appBarTheme: const AppBarTheme(
  //           backgroundColor: AppColor.graymodern50,
  //           surfaceTintColor: AppColor.graymodern50),
  //     );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        fontFamily: 'Suit',
        useMaterial3: true,
        highlightColor: AppColor.transparent,
        splashColor: AppColor.transparent,
        scaffoldBackgroundColor: AppColor.graymodern950,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.graymodern950,
            surfaceTintColor: AppColor.graymodern950),
      );
}

extension CustomTextStyles on TextTheme {
  TextStyle get text3XL => TextStyle(
        fontSize: 25.sp,
      );

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
