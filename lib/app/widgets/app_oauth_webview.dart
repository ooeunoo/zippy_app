import 'dart:async';

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
  bool isRedirectHandled = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _handleRedirect(String url) {
    if (isRedirectHandled) return;

    try {
      final uri = Uri.parse(url);
      if (uri.scheme == 'com.miro.zippy' && uri.host == 'login-callback') {
        isRedirectHandled = true;
        final code = uri.queryParameters['code'];
        debugPrint('Got authorization code: $code');

        if (mounted) {
          // 딜레이를 주어 Supabase가 내부적으로 처리할 시간을 줍니다
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.of(context).pop(true);
          });
        }
      }
    } catch (e) {
      debugPrint('Error handling redirect: $e');
      if (mounted && !isRedirectHandled) {
        Navigator.of(context).pop(false);
      }
    }
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation Request: ${request.url}');
            final url = request.url;

            // Supabase 콜백 URL 허용
            if (url.contains('auth/v1/callback')) {
              debugPrint('Processing Supabase callback');
              return NavigationDecision.navigate;
            }

            // 앱 스키마 리다이렉트 처리
            if (url.startsWith('com.miro.zippy://')) {
              debugPrint('Processing app scheme redirect');
              _handleRedirect(url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            if (url.startsWith('com.miro.zippy://')) {
              _handleRedirect(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (isRedirectHandled) return;
            debugPrint('Web resource error: ${error.description}');
          },
        ),
      )
      ..setUserAgent('Mozilla/5.0')
      ..enableZoom(false);

    debugPrint('Loading OAuth URL: ${widget.url}');
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
