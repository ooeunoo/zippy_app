import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ZippyWebview extends StatefulWidget {
  final String uri;

  const ZippyWebview({
    super.key,
    required this.uri,
  });

  @override
  State<ZippyWebview> createState() => _ZippyWebviewState();
}

class _ZippyWebviewState extends State<ZippyWebview> {
  String get uri => widget.uri;

  late double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(uri),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          //
          progressBar(_progress)
        ],
      )),
    );
  }
}

Widget progressBar(double progress) {
  return progress < 1
      ? Container(child: LinearProgressIndicator(value: progress))
      : const SizedBox();
}
