import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';

class AppInAppWebView extends StatefulWidget {
  final Uri uri;

  const AppInAppWebView({
    Key? key,
    required this.uri,
  }) : super(key: key);

  @override
  _AppInAppWebViewState createState() => _AppInAppWebViewState();
}

class _AppInAppWebViewState extends State<AppInAppWebView> {
  late final WebViewController _webViewController;
  final RxBool _isLoading = true.obs;
  final RxDouble _progress = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onLoadStart,
          onPageFinished: _onLoadStop,
          onProgress: _onProgressChanged,
          onWebResourceError: _onReceivedError,
        ),
      )
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Obx(() => _isLoading.value
                ? LinearProgressIndicator(
                    value: _progress.value,
                    backgroundColor: Colors.white,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColor.brand600),
                  )
                : const SizedBox.shrink()),
            Expanded(child: _buildWebView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
            color: AppColor.graymodern400,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => _webViewController.reload(),
            color: AppColor.graymodern400,
          ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await _webViewController.reload();
          },
          color: AppColor.brand400,
          child: WebViewWidget(
            controller: _webViewController,
            gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
          ),
        ),
      ],
    );
  }

  void _onLoadStart(String url) {
    debugPrint("WebView Started Loading: $url");
    _isLoading.value = true;
  }

  void _onLoadStop(String url) {
    debugPrint("WebView Finished Loading: $url");
    _isLoading.value = false;
  }

  void _onProgressChanged(int progress) {
    debugPrint("WebView Progress: $progress");
    _progress.value = progress / 100;
  }

  void _onReceivedError(WebResourceError error) {
    debugPrint("WebView Error: ${error.errorCode} - ${error.description}");
    _isLoading.value = false;
  }
}
