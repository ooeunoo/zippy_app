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
  bool _isScrolledDown = false;
  bool _isKeyPointsModalOpen = false;

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

    setState(() {
      _isKeyPointsModalOpen = true;
    });

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {}, // 내부 클릭 시 이벤트 가로채기
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            margin: EdgeInsets.symmetric(
              horizontal: AppDimens.width(16),
              vertical: AppDimens.height(50),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.graymodern900,
                  AppColor.graymodern800.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.size(24),
                    vertical: AppDimens.size(20),
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.graymodern800.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
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
                            decoration: BoxDecoration(
                              color: AppColor.yellow500.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: AppColor.yellow500,
                              size: AppDimens.size(20),
                            ),
                          ),
                          AppSpacerH(value: AppDimens.width(12)),
                          AppText(
                            'AI 요약',
                            style: Theme.of(context).textTheme.textLG.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isKeyPointsModalOpen = false;
                          });
                          Get.back();
                        },
                        icon: Container(
                          padding: EdgeInsets.all(AppDimens.size(8)),
                          decoration: BoxDecoration(
                            color: AppColor.graymodern700.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColor.gray300,
                            size: AppDimens.size(20),
                          ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppDimens.size(24)),
                    itemCount: widget.article.keyPoints.length,
                    separatorBuilder: (context, index) =>
                        AppSpacerV(value: AppDimens.height(16)),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(AppDimens.size(16)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColor.graymodern800.withOpacity(0.6),
                              AppColor.graymodern800.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColor.graymodern700.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: AppDimens.width(28),
                              height: AppDimens.height(28),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColor.yellow500,
                                    AppColor.yellow400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.yellow500.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: AppText(
                                '${index + 1}',
                                style:
                                    Theme.of(context).textTheme.textSM.copyWith(
                                          color: AppColor.graymodern900,
                                          fontWeight: FontWeight.w900,
                                        ),
                              ),
                            ),
                            AppSpacerH(value: AppDimens.width(16)),
                            Expanded(
                              child: AppText(
                                widget.article.keyPoints[index],
                                style:
                                    Theme.of(context).textTheme.textMD.copyWith(
                                          color: Colors.white,
                                          height: 1.6,
                                          letterSpacing: 0.3,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
    ).whenComplete(() {
      setState(() {
        _isKeyPointsModalOpen = false;
      });
    });
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
                      icon: const Icon(Icons.share),
                      onPressed: () => articleService.onHandleShareArticle(
                        widget.article,
                      ),
                    ),
                  ),
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

                    if (y > _lastScrollY && y > 0) {
                      setState(() {
                        _isScrolledDown = true;
                      });
                    }

                    if (y <= 0 && y < _lastScrollY) {
                      if (!_isScrolledDown) {
                        Get.back();
                      }
                    }

                    if (y == 0) {
                      setState(() {
                        _isScrolledDown = false;
                      });
                    }

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
          if (!_isKeyPointsModalOpen)
            Positioned(
              left: AppDimens.width(16),
              right: AppDimens.width(16),
              bottom: AppDimens.height(30),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: FloatingActionButton(
                      onPressed: _showKeyPoints,
                      backgroundColor: AppColor.graymodern900,
                      elevation: 4,
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
                                  fontWeight: AppFontWeight.semibold,
                                  letterSpacing: -0.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacerV(value: AppDimens.height(16)),
                  Container(
                    width: double.infinity,
                    child: FloatingActionButton(
                      onPressed: () => Get.back(),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimens.height(12),
                          horizontal: AppDimens.width(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: AppColor.graymodern900,
                              size: AppDimens.width(20),
                            ),
                            AppSpacerH(value: AppDimens.width(8)),
                            AppText(
                              '나가기',
                              style:
                                  Theme.of(context).textTheme.textSM.copyWith(
                                        color: AppColor.graymodern900,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
