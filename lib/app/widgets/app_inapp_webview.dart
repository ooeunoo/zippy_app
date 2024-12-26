import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class AppArticleInWebView extends StatefulWidget {
  final Article article;
  final Function? handleUpdateInteraction;

  const AppArticleInWebView({
    super.key,
    required this.article,
    this.handleUpdateInteraction,
  });

  @override
  State<AppArticleInWebView> createState() => _AppArticleInWebViewState();
}

class _AppArticleInWebViewState extends State<AppArticleInWebView> {
  final ArticleService articleService = Get.find();
  final BookmarkService bookmarkService = Get.find();

  DateTime? _startTime;
  bool _isScrolling = false;
  double _lastScrollY = 0;
  DateTime _lastScrollTime = DateTime.now();
  late InAppWebViewController? _webViewController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _isScrolling = false; // 초기 상태는 스크롤하지 않음
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _handleUserInteraction();
    super.dispose();
  }

  void _handleUserInteraction() {
    final duration = DateTime.now().difference(_startTime!);
    if (widget.handleUpdateInteraction != null) {
      widget.handleUpdateInteraction!(0, duration.inSeconds);
    }
  }

  void _showKeyPoints() {
    if (widget.article.keyPoints.isEmpty) {
      Get.snackbar(
        '알림',
        '요약 정보가 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
          vertical: AppDimens.height(16),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: AppColor.graymodern900,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.width(12),
                  vertical: AppDimens.height(20),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.graymodern800,
                      AppColor.graymodern900,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppDimens.size(8)),
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColor.yellow500,
                            size: AppDimens.size(24),
                          ),
                        ),
                        AppSpacerH(value: AppDimens.width(16)),
                        AppText(
                          'AI 요약',
                          style: Theme.of(context).textTheme.textMD.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColor.gray400,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.width(24),
                  ),
                  child: Column(
                    children:
                        widget.article.keyPoints.asMap().entries.map((entry) {
                      final index = entry.key;
                      final point = entry.value;
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: AppDimens.height(12),
                        ),
                        padding: EdgeInsets.all(AppDimens.size(16)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.graymodern800,
                              AppColor.graymodern900,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColor.graymodern700,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.width(10),
                                vertical: AppDimens.height(4),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.yellow500,
                                    AppColor.yellow500.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AppText(
                                '${index + 1}',
                                style:
                                    Theme.of(context).textTheme.textSM.copyWith(
                                          color: AppColor.graymodern900,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                              ),
                            ),
                            AppSpacerH(value: AppDimens.width(12)),
                            Expanded(
                              child: Text(
                                point,
                                style:
                                    Theme.of(context).textTheme.textMD.copyWith(
                                          color: AppColor.white,
                                          height: 1.5,
                                          letterSpacing: -0.3,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              AppSpacerV(value: AppDimens.height(12)),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            children: [
              AppHeader(
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
                title: const SizedBox.shrink(),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: AppDimens.width(12)),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Obx(
                        () => AppSvg(
                          bookmarkService.isBookmarked(widget.article.id!) !=
                                  null
                              ? Assets.bookmark
                              : Assets.bookmarkLine,
                          color: bookmarkService
                                      .isBookmarked(widget.article.id!) !=
                                  null
                              ? AppColor.brand500
                              : AppColor.black,
                        ),
                      ),
                      onPressed: () => articleService.onHandleBookmarkArticle(
                        widget.article,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(widget.article.link),
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                    transparentBackground: true,
                  ),
                  onReceivedError: (controller, request, error) {},
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (controller, url) {},
                  onLoadStop: (controller, url) {},
                  onProgressChanged: (controller, progress) {
                    if (progress == 100 && mounted) {}
                  },
                  onScrollChanged: (controller, x, y) async {
                    if (!mounted) return;

                    final now = DateTime.now();
                    final scrollDelta = y - _lastScrollY;
                    final timeDelta =
                        now.difference(_lastScrollTime).inMilliseconds;

                    // 스크롤 속도 계산 (pixels/ms)
                    final scrollSpeed =
                        timeDelta > 0 ? scrollDelta.abs() / timeDelta : 0;

                    // 스크롤 중일 때
                    if (scrollSpeed > 0) {
                      setState(() {
                        _isScrolling = true;
                      });

                      // 이전 타이머가 있다면 취소
                      _scrollTimer?.cancel();
                    }

                    // 새로운 타이머 시작
                    _scrollTimer = Timer(const Duration(milliseconds: 100), () {
                      if (mounted) {
                        final currentTime = DateTime.now();
                        final idleTime =
                            currentTime.difference(now).inMilliseconds;

                        // 100ms 동안 새로운 스크롤 이벤트가 없었다면 스크롤이 멈춘 것으로 판단
                        if (idleTime >= 100) {
                          setState(() {
                            _isScrolling = false;
                          });
                        }
                      }
                    });

                    _lastScrollY = y.toDouble();
                    _lastScrollTime = now;
                  },
                  gestureRecognizers: Set()
                    ..add(Factory(() => VerticalDragGestureRecognizer())),
                ),
              ),
            ],
          ),
          Positioned(
            right: AppDimens.width(16),
            bottom: AppDimens.height(60),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColor.graymodern900,
                      AppColor.graymodern800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.gray900.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showKeyPoints,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.width(20),
                        vertical: AppDimens.height(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppColor.yellow500,
                            size: AppDimens.width(20),
                          ),
                          AppSpacerH(value: AppDimens.width(10)),
                          AppText(
                            'AI 요약',
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: AppColor.yellow500,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
