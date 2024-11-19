// lib/app/services/webview.service.dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/widgets/app_inapp_webview.dart';

class WebViewService extends GetxService {
  // 웹뷰 설정 관리
  InAppWebViewSettings get _defaultSettings => InAppWebViewSettings(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnLoadResource: true,
        javaScriptEnabled: true,
        cacheEnabled: true,
        clearCache: false,
        allowsInlineMediaPlayback: true,
        enableViewportScale: true,
        domStorageEnabled: true,
        useHybridComposition: true,
      );

  // URL 유효성 검사 및 정규화
  Uri? _validateAndNormalizeUrl(String url) {
    if (url.isEmpty) return null;

    String normalizedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      normalizedUrl = 'https://$url';
    }

    try {
      final uri = Uri.parse(normalizedUrl);
      if (!uri.hasScheme) return null;
      return uri;
    } catch (e) {
      debugPrint('URL parsing error: $e');
      return null;
    }
  }

  // 웹뷰 표시
  void showWebView(String url) {
    final uri = _validateAndNormalizeUrl(url);
    if (uri == null) {
      debugPrint('Invalid URL');
      return;
    }

    Get.bottomSheet(
      AppInAppWebView(uri: uri, settings: _defaultSettings),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }
}
