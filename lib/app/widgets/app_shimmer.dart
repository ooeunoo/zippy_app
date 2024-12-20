import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zippy/app/styles/color.dart';

class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.graymodern900,
      highlightColor: AppColor.graymodern800,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
