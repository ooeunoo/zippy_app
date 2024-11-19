import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';

class AppInAppWebView extends StatefulWidget {
  final Uri uri;
  final InAppWebViewSettings settings;

  const AppInAppWebView({
    Key? key,
    required this.uri,
    required this.settings,
  }) : super(key: key);

  @override
  _AppInAppWebViewState createState() => _AppInAppWebViewState();
}

class _AppInAppWebViewState extends State<AppInAppWebView> {
  InAppWebViewController? _webViewController;
  final RxBool _isLoading = true.obs;
  final RxDouble _progress = 0.0.obs;

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
            Expanded(child: _buildWebView()),
            Obx(() => _isLoading.value
                ? LinearProgressIndicator(value: _progress.value)
                : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40,
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
          const Expanded(
            child: Center(
              child: Text(
                '원문 보기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      key: UniqueKey(),
      initialUrlRequest: URLRequest(url: WebUri(widget.uri.toString())),
      initialSettings: widget.settings,
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: _onLoadStart,
      onLoadStop: _onLoadStop,
      onProgressChanged: _onProgressChanged,
      onReceivedError: _onReceivedError,
    );
  }

  void _onLoadStart(InAppWebViewController controller, WebUri? url) {
    debugPrint("WebView Started Loading: ${url?.toString()}");
    _isLoading.value = true;
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? url) {
    debugPrint("WebView Finished Loading: ${url?.toString()}");
    _isLoading.value = false;
  }

  void _onProgressChanged(InAppWebViewController controller, int progress) {
    debugPrint("WebView Progress: $progress");
    _progress.value = progress / 100;
  }

  void _onReceivedError(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error) {
    debugPrint("WebView Error: ${error.type} - ${error.description}");
    debugPrint("Failed URL: ${request.url}");
    _isLoading.value = false;
    Get.snackbar('오류 발생', '웹페이지를 불러오는 데 실패했습니다: ${error.description}');
  }
}
