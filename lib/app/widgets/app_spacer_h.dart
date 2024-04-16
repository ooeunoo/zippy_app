import 'package:flutter/material.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';

class AppSpacerH extends StatelessWidget {
  const AppSpacerH({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: value ?? AppDimens.width(20),
    );
  }
}
