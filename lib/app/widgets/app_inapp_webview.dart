import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_svg.dart';
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
  bool _isScrolledDown = false;
  double _lastScrollY = 0;
  late InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _handleUserInteraction();
    super.dispose();
  }

  void _handleUserInteraction() {
    final duration = DateTime.now().difference(_startTime!);
    if (widget.handleUpdateInteraction != null) {
      widget.handleUpdateInteraction!(0, duration.inSeconds);
    }
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
                  onPressed: () {
                    Get.back();
                  },
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
                    url: WebUri(widget.article.link!),
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

                    _lastScrollY = y.toDouble();
                  },
                  gestureRecognizers: Set()
                    ..add(Factory(() => VerticalDragGestureRecognizer())),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
