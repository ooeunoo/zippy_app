import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebview extends StatefulWidget {
  final String uri;

  const AppWebview({
    super.key,
    required this.uri,
  });

  @override
  State<AppWebview> createState() => _AppWebviewState();
}

class _AppWebviewState extends State<AppWebview> {
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
            initialSettings: InAppWebViewSettings(
                // javaScriptCanOpenWindowsAutomatically: true,
                // javaScriptEnabled: true,
                // //   useOnDownloadStart: true,
                // //   useOnLoadResource: true,
                // //   useShouldOverrideUrlLoading: true,
                // mediaPlaybackRequiresUserGesture: false,
                // allowFileAccessFromFileURLs: true,
                // horizontalScrollBarEnabled: false,

                // //   allowUniversalAccessFromFileURLs: true,
                // //   verticalScrollBarEnabled: true,
                // userAgent: null,
                // //   useHybridComposition: true,
                // //   allowContentAccess: true,
                // //   builtInZoomControls: true,
                // //   thirdPartyCookiesEnabled: true,
                // //   allowFileAccess: true,
                // //   supportMultipleWindows: true,
                // allowsInlineMediaPlayback: true,
                //   allowsBackForwardNavigationGestures: true,
                ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onReceivedError: (InAppWebViewController controller,
                WebResourceRequest request, WebResourceError error) {},
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
