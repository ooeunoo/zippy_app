import 'package:flutter/widgets.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.gray600,
      height: AppDimens.size(1),
    );
  }
}
