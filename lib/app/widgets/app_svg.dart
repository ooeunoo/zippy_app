import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppSvg extends StatelessWidget {
  final String path;
  final Color? color;
  final double? size;

  const AppSvg(this.path, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return SvgPicture.asset(
        path,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        width: size ?? AppDimens.size(24),
        height: size ?? AppDimens.size(24),
      );
    } else {
      return SvgPicture.asset(
        path,
        width: size ?? AppDimens.size(24),
        height: size ?? AppDimens.size(24),
      );
    }
  }
}
