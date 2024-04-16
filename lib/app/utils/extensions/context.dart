import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  static late BuildContext ctx;

  showSnackBar(SnackBar snackbar) =>
      ScaffoldMessenger.of(this).showSnackBar(snackbar);
}
