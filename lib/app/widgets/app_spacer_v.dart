import 'package:flutter/material.dart';
import 'package:zippy/app/utils/styles/dimens.dart';

class AppSpacerV extends StatelessWidget {
  const AppSpacerV({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: value ?? AppDimens.height(20),
    );
  }
}
