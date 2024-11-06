import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/enum/article_view_type.enum.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;
  final Function(int, int)? handleUpdateUserInteraction;
  final ScrollController? scrollController; // 추가

  const ZippyArticleView({
    super.key,
    required this.article,
    this.handleUpdateUserInteraction,
    this.scrollController, // 추가
  });

  @override
  State<ZippyArticleView> createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> with RouteAware {
  DateTime? _startTime;
  late ArticleViewType _viewType;
  late WebViewController _webViewController;
  bool _isWebViewLoading = true;

  @override
  void initState() {
    super.initState();
    print(widget.article.link);
    _startTime = DateTime.now();
    _viewType = ArticleViewType.Keypoint;
    _initWebViewController();
  }

  @override
  void dispose() {
    _handleUserInteraction();
    super.dispose();
  }

  void _handleUserInteraction() {
    final duration = DateTime.now().difference(_startTime!);
    widget.handleUpdateUserInteraction?.call(0, duration.inSeconds);
  }

// WebViewController 초기화 부분도 수정
  void _initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isWebViewLoading = true;
            });
          },
          onPageFinished: (String url) async {
            // 웹뷰 스타일 및 스크롤 설정
            await _webViewController.runJavaScript('''
            document.querySelector('meta[name="viewport"]')?.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0');
            document.body.style.overflow = 'scroll';
            document.documentElement.style.overflow = 'scroll';
            true;
          ''');
            setState(() {
              _isWebViewLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.article.link));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) _handleUserInteraction();
      },
      child: Scaffold(
        body: _buildBody(),
        floatingActionButton: _buildFloatingButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildBody() {
    if (_viewType == ArticleViewType.Original) {
      return SafeArea(
        bottom: false,
        child: Column(
          children: [
            // WebView
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: _webViewController,
                      gestureRecognizers: {
                        Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer(),
                        ),
                      },
                    ),
                    if (_isWebViewLoading)
                      Container(
                        color: AppColor.gray900,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.brand600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // FAB을 위한 여백
            SizedBox(height: AppDimens.height(80)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: AppDimens.height(12)),
          width: AppDimens.width(40),
          height: AppDimens.height(4),
          decoration: BoxDecoration(
            color: AppColor.graymodern600,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            children: [
              _buildEngagementSection(),
              AppSpacerV(value: AppDimens.height(15)),
              const AppDivider(color: AppColor.gray600, height: 2),
              AppSpacerV(value: AppDimens.height(15)),
              switch (_viewType) {
                ArticleViewType.Keypoint => _buildKeyPoints(),
                ArticleViewType.Summary => _buildSummary(),
                _ => const SizedBox.shrink(),
              },
              AppSpacerV(value: AppDimens.height(80)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            widget.article.title,
            style: Theme.of(context).textTheme.textXL.copyWith(
                  color: AppColor.gray50,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
          ),
          AppSpacerV(value: AppDimens.height(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.remove_red_eye,
                  size: 16, color: AppColor.gray400),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                '2.4k',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
              AppSpacerH(value: AppDimens.width(16)),
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: AppColor.gray400),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                '42',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints() {
    if (widget.article.keyPoints == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColor.brand600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppDimens.width(8)),
              AppText(
                '이것만 알면 끝!',
                style: Theme.of(context).textTheme.textLG.copyWith(
                      color: AppColor.gray50,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.height(16)),
          ...widget.article.keyPoints!.map((point) => _buildKeyPoint(point)),
        ],
      ),
    );
  }

  Widget _buildKeyPoint(String point) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.height(5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // center로 변경
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppDimens.height(5)), // 미세 조정
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: AppColor.brand600,
                ),
              ),
              AppSpacerH(value: AppDimens.width(4)),
              Expanded(
                child: AppText(
                  point,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppColor.gray200,
                        height: 1.5,
                      ),
                ),
              ),
            ],
          ),
          AppSpacerV(value: AppDimens.height(5)),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: widget.article.formattedContent,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray200,
                    height: 1.6,
                  ),
              h1: Theme.of(context).textTheme.textXL.copyWith(
                    color: AppColor.gray50,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
              h2: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppColor.gray50,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
              h3: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppColor.gray50,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
              strong: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray50,
                    fontWeight: FontWeight.bold,
                  ),
              em: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray200,
                    fontStyle: FontStyle.italic,
                  ),
              blockquote: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray400,
                    height: 1.6,
                  ),
              blockquoteDecoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColor.brand600,
                    width: 4,
                  ),
                ),
              ),
              code: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.brand600,
                    fontFamily: 'monospace',
                  ),
              codeblockDecoration: BoxDecoration(
                color: AppColor.gray800,
                borderRadius: BorderRadius.circular(8),
              ),
              listBullet: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray200,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginal() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            WebViewWidget(
              controller: _webViewController,
            ),
            if (_isWebViewLoading)
              Container(
                color: AppColor.gray900,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.brand600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    final availableTypes =
        ArticleViewType.values.where((type) => type != _viewType).toList();

    final buttons = List.generate(availableTypes.length, (index) {
      final type = availableTypes[index];
      final config = type.buttonConfig;

      // 위치에 따라 마진 설정
      EdgeInsets margin;
      if (index == 0) {
        margin = EdgeInsets.only(right: AppDimens.width(8));
      } else if (index == availableTypes.length - 1) {
        margin = EdgeInsets.only(left: AppDimens.width(8));
      } else {
        margin = EdgeInsets.symmetric(horizontal: AppDimens.width(8));
      }

      return Expanded(
        child: Container(
          margin: margin,
          height: AppDimens.height(48),
          child: FloatingActionButton.extended(
            heroTag: type.name,
            backgroundColor: config.$3,
            onPressed: () => setState(() => _viewType = type),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  config.$1,
                  color: AppColor.gray50,
                  size: 20,
                ),
                AppSpacerH(value: AppDimens.width(8)),
                AppText(
                  config.$2,
                  style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppColor.gray50,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }
}
