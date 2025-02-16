// lib/app/services/webview.service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/widgets/app_article_view.dart';
import 'package:zippy/app/widgets/app_inapp_webview.dart';
import 'package:zippy/domain/model/article.model.dart';

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

  void showArticleWebView(
    Article article,
    Function? handleUpdateInteraction,
  ) {
    final uri = _validateAndNormalizeUrl(article.link);
    if (uri == null) {
      Get.snackbar(
        '오류',
        '올바르지 않은 URL입니다',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Get.to(
    //   () => AppArticleView(
    //     article: article,
    //     handleUpdateInteraction: handleUpdateInteraction,
    //   ),
    // );
    Get.bottomSheet(
      AppArticleInWebView(
        article: article,
        handleUpdateInteraction: handleUpdateInteraction,
      ),
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }
}
