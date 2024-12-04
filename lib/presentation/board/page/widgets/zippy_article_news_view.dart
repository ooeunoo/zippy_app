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
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/domain/model/source.model.dart';

class ZippyArticleNewsView extends StatefulWidget {
  final Article article;

  const ZippyArticleNewsView({super.key, required this.article});

  @override
  State<ZippyArticleNewsView> createState() => _ZippyArticleNewsViewState();
}

class _ZippyArticleNewsViewState extends State<ZippyArticleNewsView> {
  final articleService = Get.find<ArticleService>();
  bool isKeyPointsExpanded = false;
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.graymodern950,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(24),
              ),
              child: _buildTitle(context),
            ),
            AppSpacerV(value: AppDimens.height(16)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(24),
              ),
              child: _buildMetaInfo(context),
            ),
            AppSpacerV(value: AppDimens.height(16)),
            AppDivider(color: AppColor.brand800, height: 4),
            AppSpacerV(value: AppDimens.height(16)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(24),
              ),
              child: _buildKeyPointsCard(context),
            ),
            AppSpacerV(value: AppDimens.height(16)),
            _buildContent(),
            AppSpacerV(value: AppDimens.height(16)),
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
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColor.graymodern200),
            onPressed: () =>
                articleService.onHandleArticleSupportMenu(widget.article),
          ),
        ],
      ),
    );
  }

// _buildTitle 메서드 수정
  Widget _buildTitle(BuildContext context) {
    return AppText(
      widget.article.title,
      style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.graymodern100,
            height: AppDimens.height(1.2), // 120% line height
            fontWeight: AppFontWeight.semibold,
          ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    Source? source = articleService.getSourceById(widget.article.sourceId);

    return Column(
      children: [
        Row(
          children: [
            AppText(
                '${source?.platform?.name ?? ''} | ${widget.article.published.toLocal().year}.${widget.article.published.toLocal().month}.${widget.article.published.toLocal().day} ${widget.article.published.toLocal().hour}:${widget.article.published.toLocal().minute.toString().padLeft(2, '0')}',
                style: Theme.of(context)
                    .textTheme
                    .textXS
                    .copyWith(color: AppColor.graymodern400)),
          ],
        ),
        AppSpacerV(value: AppDimens.height(4)),
        Row(
          children: [
            AppText(widget.article.author,
                style: Theme.of(context).textTheme.textXS.copyWith(
                      color: AppColor.graymodern400,
                    )),
          ],
        ),
      ],
    );
  }

// _buildContent 메서드 수정
  Widget _buildContent() {
    final formattedContent = widget.article.content
        .split('\n')
        .map((paragraph) => '$paragraph\n\n')
        .join('')
        .replaceAll(RegExp(r'\n\n+'), '\n\n')
        .trim();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(24), // 24px 좌우 여백
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: formattedContent,
            imageBuilder: (uri, title, alt) {
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
                      padding: EdgeInsets.only(top: AppDimens.height(8)),
                      child: Text(
                        alt,
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.graymodern400,
                            ),
                      ),
                    ),
                ],
              );
            },
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern300,
                    fontSize: AppDimens.size(17), // 17px 본문 크기
                    height: AppDimens.height(1.55), // 155% line height
                    letterSpacing: AppDimens.width(-0.4), // letter spacing -0.4
                  ),
              // 17px의 75%인 13px가 너무 넓어서 8px로 조정
              pPadding: EdgeInsets.symmetric(
                vertical: AppDimens.height(6),
              ),
              strong: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern500,
                    fontWeight: AppFontWeight.bold,
                  ),
              blockquote: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern500,
                    height: AppDimens.height(1.55),
                    letterSpacing: AppDimens.width(-0.4),
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
                    height: AppDimens.height(1.2),
                  ),
              h2: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppColor.graymodern100,
                    fontWeight: AppFontWeight.bold,
                    height: AppDimens.height(1.2),
                  ),
              h3: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern100,
                    fontWeight: AppFontWeight.bold,
                    height: AppDimens.height(1.2),
                  ),
              code: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern500,
                    backgroundColor: AppColor.graymodern800.withOpacity(0.3),
                  ),
              codeblockDecoration: BoxDecoration(
                color: AppColor.graymodern800.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimens.radius(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPointsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKeyPointsExpanded = !isKeyPointsExpanded;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(AppDimens.width(16)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.brand900, AppColor.graymodern900],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radius(12)),
          border: Border.all(color: AppColor.brand800, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon(
                    //   Icons.stars_rounded,
                    //   color: AppColor.blue400,
                    //   size: AppDimens.size(20),
                    // ),
                    // AppSpacerH(value: AppDimens.width(8)),
                    AppText(
                      '주요 포인트',
                      style: Theme.of(context).textTheme.textLG.copyWith(
                            color: AppColor.brand400,
                            fontWeight: AppFontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Icon(
                  isKeyPointsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.brand400,
                ),
              ],
            ),
            if (isKeyPointsExpanded) ...[
              AppSpacerV(value: AppDimens.height(16)),
              ...widget.article.keyPoints.map((point) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.height(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: AppDimens.height(4),
                          ),
                          child: Icon(
                            Icons.circle_outlined,
                            color: AppColor.brand600,
                            size: AppDimens.size(16),
                          ),
                        ),
                        AppSpacerH(value: AppDimens.width(8)),
                        Expanded(
                          child: AppText(
                            point,
                            style: Theme.of(context).textTheme.textMD.copyWith(
                                  color: AppColor.graymodern200,
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
