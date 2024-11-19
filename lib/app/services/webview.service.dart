// lib/app/services/webview.service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zippy/app/widgets/app_inapp_webview.dart';

class WebViewService extends GetxService {
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

  void showWebView(String url) {
    final uri = _validateAndNormalizeUrl(url);
    if (uri == null) {
      Get.snackbar(
        '오류',
        '올바르지 않은 URL입니다',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      AppInAppWebView(uri: uri),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }
}
