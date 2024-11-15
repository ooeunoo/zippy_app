import 'package:flutter/material.dart';

extension NumberExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }

  String formatViewCount() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      double value = this / 1000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}k';
    } else {
      double value = this / 1000000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}M';
    }
  }
}
