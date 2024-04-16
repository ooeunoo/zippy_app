import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CocomuWebview extends StatelessWidget {
  final WebViewController controller;
  final bool loading;

  const CocomuWebview(
      {super.key, required this.controller, required this.loading});

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CupertinoActivityIndicator())
        : WebViewWidget(
            controller: controller,
          );
  }
}
