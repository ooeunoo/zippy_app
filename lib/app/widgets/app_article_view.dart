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

class AppArticleView extends StatefulWidget {
  final Article article;
  final Function? handleUpdateInteraction;

  const AppArticleView({
    super.key,
    required this.article,
    this.handleUpdateInteraction,
  });

  @override
  State<AppArticleView> createState() => _AppArticleViewState();
}

class _AppArticleViewState extends State<AppArticleView> {
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
    _isScrolling = false;
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
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
          vertical: AppDimens.height(16),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppColor.graymodern900,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimens.size(16)),
                decoration: BoxDecoration(
                  color: AppColor.graymodern800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: AppDimens.size(12)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppColor.yellow500,
                            size: AppDimens.size(18),
                          ),
                          AppSpacerH(value: AppDimens.width(8)),
                          AppText(
                            'AI 요약',
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isKeyPointsModalOpen = false;
                        });
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColor.gray400,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(AppDimens.size(16)),
                  itemCount: widget.article.keyPoints.length,
                  separatorBuilder: (context, index) =>
                      AppSpacerV(value: AppDimens.height(16)),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(AppDimens.size(12)),
                      decoration: BoxDecoration(
                        color: AppColor.graymodern800.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: AppDimens.width(22),
                            height: AppDimens.height(22),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.yellow500,
                              shape: BoxShape.circle,
                            ),
                            child: AppText(
                              '${index + 1}',
                              style:
                                  Theme.of(context).textTheme.textSM.copyWith(
                                        color: AppColor.graymodern900,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                          AppSpacerH(value: AppDimens.width(12)),
                          Expanded(
                            child: AppText(
                              widget.article.keyPoints[index],
                              style:
                                  Theme.of(context).textTheme.textSM.copyWith(
                                        color: Colors.white,
                                        height: 1.4,
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
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
    ).whenComplete(() {
      setState(() {
        _isKeyPointsModalOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
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
              final timeDelta = now.difference(_lastScrollTime).inMilliseconds;

              final scrollSpeed =
                  timeDelta > 0 ? scrollDelta.abs() / timeDelta : 0;

              if (scrollSpeed > 0) {
                setState(() {
                  _isScrolling = true;
                });

                _scrollTimer?.cancel();
              }

              _scrollTimer = Timer(const Duration(milliseconds: 100), () {
                if (mounted) {
                  final currentTime = DateTime.now();
                  final idleTime = currentTime.difference(now).inMilliseconds;

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
