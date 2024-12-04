import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppDimens {
  AppDimens._();

  static double screenW = 375;
  static double screenH = 812;

  static size(double s) => s.sp;
  static width(double s) => s.w;
  static height(double s) => s.h;
  static radius(double s) => s.r;
}
