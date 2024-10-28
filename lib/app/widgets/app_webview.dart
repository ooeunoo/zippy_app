import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';

class AppWebview extends StatefulWidget {
  final String? title;
  final String uri;

  const AppWebview({
    super.key,
    this.title,
    required this.uri,
  });

  @override
  State<AppWebview> createState() => _AppWebviewState();
}

class _AppWebviewState extends State<AppWebview> {
  String? get title => widget.title;
  String get uri => widget.uri;

  late double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  void dispose() {
    inAppWebViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null ? appBar(context, title) : null,
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(uri),
              ),
              initialSettings: InAppWebViewSettings(
                  // // javaScriptCanOpenWindowsAutomatically: true,
                  // // javaScriptEnabled: true,
                  // // useOnDownloadStart: true,
                  // // useOnLoadResource: true,
                  // // useShouldOverrideUrlLoading: true,
                  // // mediaPlaybackRequiresUserGesture: false,
                  // // allowFileAccessFromFileURLs: true,
                  // // horizontalScrollBarEnabled: false,
                  // //   allowUniversalAccessFromFileURLs: true,
                  // //   verticalScrollBarEnabled: true,
                  // //   userAgent: null,
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
        ),
      ),
    );
  }
}

AppBar appBar(BuildContext context, String? title) {
  return AppBar(
    centerTitle: false,
    leading: Container(),
    leadingWidth: AppDimens.width(5),
    title: Row(
      children: [
        GestureDetector(
          onTap: Get.back,
          child: const Icon(
            Icons.chevron_left,
            size: 30,
            color: AppColor.white,
          ),
        ),
        AppSpacerH(value: AppDimens.size(5)),
        Expanded(
          child: AppText(
            title ?? '',
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .textLG
                .copyWith(color: AppColor.gray100),
          ),
        ),
      ],
    ),
    // bottom: tabBar()
  );
}

Widget progressBar(double progress) {
  return progress < 1
      ? Container(child: LinearProgressIndicator(value: progress))
      : const SizedBox();
}
