import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';

class ZippyArticleNewsView extends StatefulWidget {
  final Article article;
  final Function(int, int)? handleUpdateInteraction;

  const ZippyArticleNewsView({
    super.key,
    required this.article,
    required this.handleUpdateInteraction,
  });

  @override
  State<ZippyArticleNewsView> createState() => _ZippyArticleNewsViewState();
}

class _ZippyArticleNewsViewState extends State<ZippyArticleNewsView> {
  final articleService = Get.find<ArticleService>();

  DateTime? _startTime;

  final scrollController = ScrollController();
  final PageController _pageController = PageController();
  final Map<String, GlobalKey> sectionKeys = {};
  final Map<String, bool> expandedSections = {};

  @override
  void initState() {
    super.initState();
    for (var section in widget.article.sections) {
      sectionKeys[section.title] = GlobalKey();
      expandedSections[section.title] = false;
    }
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _pageController.dispose();
    scrollController.dispose();
    _handleUserInteraction();

    super.dispose();
  }

  void _handleUserInteraction() {
    final duration = DateTime.now().difference(_startTime!);
    if (widget.handleUpdateInteraction != null) {
      widget.handleUpdateInteraction!(0, duration.inSeconds);
    }
  }

  void _showSummarySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppThemeColors.bottomSheetBackground(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.radius(20)),
              topRight: Radius.circular(AppDimens.radius(20)),
            ),
            border: Border.all(
              color: AppThemeColors.bottomSheetBorder(context),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildSummaryHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.width(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummarySection(
                        context,
                        '주요 포인트',
                        widget.article.keyPoints,
                        Icons.format_list_bulleted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background(context),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  AppSpacerV(value: AppDimens.height(16)),
                  _buildMetaInfo(context),
                  _buildSummaryButton(context),
                ],
              ),
            ),
            AppSpacerV(value: AppDimens.height(16)),
            AppDivider(
              color: AppColor.brand700.withOpacity(0.1),
              height: 2,
            ),
            AppSpacerV(value: AppDimens.height(16)),
            _buildContent(),
            AppSpacerV(value: AppDimens.height(100)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppHeaderWrap(
      child: AppHeader(
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppDimens.width(12)),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                Icons.more_vert,
                color: AppThemeColors.iconColor(context),
              ),
              onPressed: () =>
                  articleService.onHandleArticleSupportMenu(widget.article),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AppText(
      widget.article.title,
      style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppThemeColors.textHighest(context),
            height: 1.2,
            fontWeight: AppFontWeight.semibold,
          ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    Source? source = articleService.getSourceById(widget.article.sourceId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaInfoRow(
          context,
          '${source?.platform?.name ?? ''} | ${widget.article.author} | ${_formatDateTime(widget.article.published)}',
        ),
      ],
    );
  }

  Widget _buildMetaInfoRow(BuildContext context, String text) {
    return Row(
      children: [
        AppText(
          text,
          style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppThemeColors.textLow(context),
              ),
        ),
      ],
    );
  }

  Widget _buildSummaryButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppDimens.height(16)),
      child: InkWell(
        onTap: _showSummarySheet,
        borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20),
            vertical: AppDimens.height(16),
          ),
          decoration: BoxDecoration(
            color: AppThemeColors.summaryButtonColor(context),
            border: Border.all(
              color: AppThemeColors.summaryButtonBorderColor(context),
            ),
            borderRadius: BorderRadius.circular(AppDimens.radius(12)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimens.size(4)),
                decoration: BoxDecoration(
                  color: AppThemeColors.transparent(context),
                  borderRadius: BorderRadius.circular(AppDimens.radius(8)),
                ),
                child: Icon(
                  Icons.article_outlined,
                  color: AppThemeColors.summaryButtonIconColor(context),
                  size: AppDimens.size(20),
                ),
              ),
              AppSpacerH(value: AppDimens.width(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '10초 요약 ',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color:
                                AppThemeColors.summaryButtonTextColor(context),
                            fontWeight: AppFontWeight.semibold,
                          ),
                    ),
                    AppSpacerV(value: AppDimens.height(4)),
                    AppText(
                      '주요 내용을 빠르게 파악하세요',
                      style: Theme.of(context).textTheme.textXS.copyWith(
                            color: AppThemeColors.textLow(context),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppThemeColors.transparent(context),
                  borderRadius: BorderRadius.circular(AppDimens.radius(6)),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppThemeColors.iconColor(context),
                  size: AppDimens.size(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final formattedContent = _formatContent(widget.article.content);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: formattedContent,
            imageBuilder: _buildMarkdownImage,
            styleSheet: _buildMarkdownStyleSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimens.width(16),
        right: AppDimens.width(16),
        top: AppDimens.height(12),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColor.brand700.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox.shrink(),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: AppDimens.width(16),
          //   ),
          //   child: AppText(
          //     '10초 요약',
          //     style: Theme.of(context).textTheme.textLG.copyWith(
          //           color: AppThemeColors.textHighest(context),
          //           fontWeight: AppFontWeight.bold,
          //         ),
          //   ),
          // ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppThemeColors.iconColor(context),
              size: AppDimens.size(24),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    String title,
    List<String> content,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 요약 내용
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: content.length,
          itemBuilder: (context, index) {
            return _buildKeyPoint(context, content[index], index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildKeyPoint(BuildContext context, String point, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(8),
        vertical: AppDimens.height(16),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppThemeColors.bottomSheetBorder(context).withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // start에서 center로 변경
        children: [
          Container(
            width: AppDimens.width(24),
            height: AppDimens.height(24),
            margin: EdgeInsets.only(right: AppDimens.width(12)),
            decoration: BoxDecoration(
              color: AppColor.brand500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimens.radius(6)),
            ),
            child: Center(
              child: AppText(
                index.toString(),
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.brand500,
                      fontWeight: AppFontWeight.bold,
                    ),
              ),
            ),
          ),
          Expanded(
            child: AppText(
              point,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppThemeColors.textHigh(context),
                    fontWeight: AppFontWeight.medium,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownImage(Uri uri, String? title, String? alt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CachedNetworkImage(
          imageUrl: uri.toString(),
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: AppDimens.height(200),
            color: AppColor.graymodern900,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: AppDimens.height(200),
            color: AppColor.graymodern900,
            child: const Icon(Icons.error),
          ),
        ),
        if (alt != null && alt.isNotEmpty && alt != "사진설명")
          Padding(
            padding: EdgeInsets.only(
              top: AppDimens.height(4),
            ),
            child: Text(
              alt,
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.graymodern400,
                  ),
            ),
          ),
      ],
    );
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      p: Theme.of(context).textTheme.textMD.copyWith(
            color: AppThemeColors.textMedium(context),
            fontSize: 17,
            height: 1.55,
            letterSpacing: -0.4,
          ),
      pPadding: EdgeInsets.symmetric(
        vertical: AppDimens.height(6),
      ),
      strong: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern500,
            fontWeight: AppFontWeight.bold,
          ),
      blockquote: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern500,
            height: 1.55,
            letterSpacing: -0.4,
            fontStyle: FontStyle.italic,
          ),
      blockquoteDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radius(8)),
        color: AppColor.graymodern800.withOpacity(0.3),
        border: const Border(
          left: BorderSide(
            color: AppColor.graymodern700,
            width: 3,
          ),
        ),
      ),
      blockquotePadding: EdgeInsets.fromLTRB(
        AppDimens.width(16),
        AppDimens.height(16),
        AppDimens.width(16),
        AppDimens.height(16),
      ),
      listBullet: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern500,
          ),
      listBulletPadding: EdgeInsets.only(
        right: AppDimens.width(16),
      ),
      listIndent: AppDimens.width(24),
      h1: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.graymodern300,
            fontWeight: AppFontWeight.bold,
            height: 1.2,
          ),
      h2: Theme.of(context).textTheme.textLG.copyWith(
            color: AppColor.graymodern100,
            fontWeight: AppFontWeight.bold,
            height: 1.2,
          ),
      h3: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern100,
            fontWeight: AppFontWeight.bold,
            height: 1.2,
          ),
      code: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern500,
            backgroundColor: AppColor.graymodern800.withOpacity(0.3),
          ),
      codeblockDecoration: BoxDecoration(
        color: AppColor.graymodern800.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimens.radius(8)),
      ),
    );
  }

  String _formatContent(String content) {
    return content
        .split('\n')
        .map((paragraph) => '$paragraph\n\n')
        .join('')
        .replaceAll(RegExp(r'\n\n+'), '\n\n')
        .trim();
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.year}.${local.month}.${local.day} ${local.hour}:${local.minute.toString().padLeft(2, '0')}';
  }
}
