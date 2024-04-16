import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;

  const AppImage(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path);
  }
}
