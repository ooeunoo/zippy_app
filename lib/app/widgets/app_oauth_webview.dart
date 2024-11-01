import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppOAuthWebView extends StatefulWidget {
  final String url;
  final String redirectUrl;

  const AppOAuthWebView({
    Key? key,
    required this.url,
    required this.redirectUrl,
  }) : super(key: key);

  @override
  State<AppOAuthWebView> createState() => _AppOAuthWebViewState();
}

class _AppOAuthWebViewState extends State<AppOAuthWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // 리다이렉트 URL이 감지되면 웹뷰를 닫고 결과 전달
            if (request.url.startsWith(widget.redirectUrl)) {
              if (mounted) {
                Navigator.of(context).pop(true); // 웹뷰 닫기
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            // 페이지 로드 완료 후 리다이렉트 URL 체크
            if (url.startsWith(widget.redirectUrl)) {
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            }
          },
        ),
      )
      // ..clearCache() // 캐시 초기화
      // ..clearLocalStorage() // 로컬 스토리지 초기화
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
