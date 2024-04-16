import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimens {
  AppDimens._();

  static double screenW = 375;
  static double screenH = 812;

  static size(int s) => s.r;
  static width(int s) => s.w;
  static height(int s) => s.h;
}
