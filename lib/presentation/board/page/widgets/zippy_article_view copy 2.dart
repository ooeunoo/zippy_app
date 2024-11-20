import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_random_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_video_player.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;

  const ZippyArticleView({super.key, required this.article});

  @override
  State<ZippyArticleView> createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> {
  final articleService = Get.find<ArticleService>();
  bool isKeyPointsExpanded = false;
  final scrollController = ScrollController();
  final Map<String, GlobalKey> sectionKeys = {};

  @override
  void initState() {
    super.initState();
    // 각 섹션에 대한 키 생성
    for (var section in widget.article.sections) {
      sectionKeys[section.title] = GlobalKey();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      // RenderBox를 사용하여 섹션의 절대 위치 계산
      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      // 현재 스크롤 위치 가져오기
      final scrollable = Scrollable.of(context);
      final ScrollPosition scrollPosition = scrollable.position;

      // AppBar 높이와 상단 여백을 고려하여 스크롤 위치 계산
      final targetOffset = scrollPosition.pixels +
          position.dy -
          MediaQuery.of(context).padding.top -
          kToolbarHeight - // AppBar 높이
          AppDimens.height(100); // 추가 여백

      scrollable.position.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
            _buildMainImage(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacerV(value: AppDimens.height(16)),
                  // Metadata Section
                  _buildMetadataRow(context),
                  AppSpacerV(value: AppDimens.height(24)),
                  // Title Section
                  _buildTitle(),
                  AppSpacerV(value: AppDimens.height(16)),

                  // Key Points Card
                  _buildKeyPointsCard(context),
                  AppSpacerV(value: AppDimens.height(32)),

                  // Content Sections
                  _buildContentSections(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppHeader _buildAppBar(BuildContext context) {
    return AppHeader(
      title: const SizedBox.shrink(),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColor.graymodern200),
          onPressed: () =>
              articleService.onHandleArticleSupportMenu(widget.article),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return AppText(
      widget.article.title,
      style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.graymodern100,
            fontWeight: AppFontWeight.bold,
            height: 1.4,
          ),
    );
  }

  Widget _buildMainImage() {
    // 모든 미디어 URL을 저장할 리스트
    List<String> allImages = List<String>.from(widget.article.images);
    List<String> allVideos = [];

    // attachments에서 미디어 타입별로 분류
    if (widget.article.attachments != null) {
      for (var attachment in widget.article.attachments!) {
        if (attachment.contentType.startsWith('image/') &&
            !allImages.contains(attachment.contentUrl)) {
          allImages.add(attachment.contentUrl);
        } else if (attachment.contentType.startsWith('video/')) {
          allVideos.add(attachment.contentUrl);
        }
      }
    }

    // 미디어가 없는 경우 랜덤 이미지 표시
    if (allImages.isEmpty && allVideos.isEmpty) {
      return SizedBox(
        height: AppDimens.height(200),
        width: double.infinity,
        child: AppRandomImage(id: widget.article.id.toString()),
      );
    }

    return SizedBox(
      height: AppDimens.height(200),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allImages.length + allVideos.length,
        itemBuilder: (context, index) {
          bool isVideo = index >= allImages.length;
          String mediaUrl =
              isVideo ? allVideos[index - allImages.length] : allImages[index];

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: (allImages.length + allVideos.length) == 1
                  ? double.infinity
                  : MediaQuery.of(context).size.width / 2,
            ),
            child:
                //  isVideo
                //     ? AppVideoPlayer(videoUrl: mediaUrl) // VideoPlayer 위젯 구현 필요
                //     :
                CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  AppRandomImage(id: widget.article.id.toString()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    final platform =
        articleService.getSourceById(widget.article.sourceId)?.platform;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.height(8),
        horizontal: AppDimens.width(8),
      ),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.circular(AppDimens.radius(8)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(8),
              vertical: AppDimens.height(4),
            ),
            decoration: BoxDecoration(
              color: AppColor.blue500.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimens.radius(4)),
            ),
            child: AppText(
              platform?.name ?? "",
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.blue400,
                    fontWeight: AppFontWeight.medium,
                  ),
            ),
          ),
          AppSpacerH(value: AppDimens.width(12)),
          Icon(
            Icons.access_time,
            size: AppDimens.size(14),
            color: AppColor.graymodern400,
          ),
          AppSpacerH(value: AppDimens.width(4)),
          AppText(
            widget.article.published.timeAgo(),
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern400,
                ),
          ),
          const Spacer(),
          _buildEngagementStats(context),
        ],
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          context,
          Icons.remove_red_eye_outlined,
          widget.article.metadata?.viewCount.toString() ?? '0',
        ),
        AppSpacerH(value: AppDimens.width(12)),
        _buildStatItem(
          context,
          Icons.thumb_up_outlined,
          widget.article.metadata?.likeCount.toString() ?? '0',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.size(14),
          color: AppColor.graymodern400,
        ),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          count,
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.graymodern400,
              ),
        ),
      ],
    );
  }

  Widget _buildKeyPointsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.width(16)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.blue900, AppColor.graymodern900],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        border: Border.all(color: AppColor.blue800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isKeyPointsExpanded = !isKeyPointsExpanded;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: AppColor.blue400,
                      size: AppDimens.size(20),
                    ),
                    AppSpacerH(value: AppDimens.width(8)),
                    AppText(
                      '주요 포인트',
                      style: Theme.of(context).textTheme.textLG.copyWith(
                            color: AppColor.blue400,
                            fontWeight: AppFontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Icon(
                  isKeyPointsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.blue400,
                ),
              ],
            ),
          ),
          if (isKeyPointsExpanded) ...[
            AppSpacerV(value: AppDimens.height(16)),
            ...widget.article.keyPoints.map((point) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.height(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColor.blue500,
                        size: AppDimens.size(16),
                      ),
                      AppSpacerH(value: AppDimens.width(12)),
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
    );
  }

  Widget _buildContentSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.article.sections.map((section) {
        return Container(
          key: sectionKeys[section.title],
          margin: EdgeInsets.only(bottom: AppDimens.height(16)),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.graymodern800,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radius(12)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              unselectedWidgetColor: AppColor.graymodern400,
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              onExpansionChanged: (isExpanded) {
                if (isExpanded) {
                  _scrollToSection(sectionKeys[section.title]!);
                }
              },
              tilePadding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(16),
                vertical: AppDimens.height(8),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimens.width(8)),
                    decoration: BoxDecoration(
                      color: AppColor.blue500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radius(8)),
                    ),
                    child: Icon(
                      Icons.article_outlined,
                      color: AppColor.blue400,
                      size: AppDimens.size(18),
                    ),
                  ),
                  AppSpacerH(value: AppDimens.width(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          section.title,
                          style: Theme.of(context).textTheme.textMD.copyWith(
                                color: AppColor.graymodern200,
                                fontWeight: AppFontWeight.semibold,
                              ),
                        ),
                        AppSpacerV(value: AppDimens.height(4)),
                        AppText(
                          '${section.content.length}개의 내용',
                          style: Theme.of(context).textTheme.textSM.copyWith(
                                color: AppColor.graymodern500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: AppDimens.width(16),
                    right: AppDimens.width(16),
                    bottom: AppDimens.height(16),
                  ),
                  child: Column(
                    children: section.content.asMap().entries.map((entry) {
                      final index = entry.key;
                      final content = entry.value;

                      return Container(
                        margin: EdgeInsets.only(
                          top: index == 0 ? 0 : AppDimens.height(16),
                        ),
                        padding: EdgeInsets.all(AppDimens.width(16)),
                        decoration: BoxDecoration(
                          color: AppColor.graymodern900,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radius(12)),
                          border: Border.all(
                            color: AppColor.graymodern800,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimens.width(8),
                                    vertical: AppDimens.height(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.blue500.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radius(4),
                                    ),
                                  ),
                                  child: AppText(
                                    'Part ${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .textXS
                                        .copyWith(
                                          color: AppColor.blue400,
                                          fontWeight: AppFontWeight.medium,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacerV(value: AppDimens.height(12)),
                            MarkdownBody(
                              data: content,
                              styleSheet: MarkdownStyleSheet(
                                p: Theme.of(context).textTheme.textMD.copyWith(
                                      color: AppColor.graymodern200,
                                      height: 1.7,
                                      letterSpacing: 0.3,
                                    ),
                                strong:
                                    Theme.of(context).textTheme.textMD.copyWith(
                                          color: AppColor.graymodern100,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                blockquote:
                                    Theme.of(context).textTheme.textMD.copyWith(
                                          color: AppColor.graymodern300,
                                          height: 1.7,
                                          letterSpacing: 0.3,
                                        ),
                                blockquoteDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radius(8),
                                  ),
                                  color:
                                      AppColor.graymodern800.withOpacity(0.3),
                                  border: Border.all(
                                    color: AppColor.graymodern700,
                                    width: 1,
                                  ),
                                ),
                                blockquotePadding: EdgeInsets.all(
                                  AppDimens.width(16),
                                ),
                                listBullet:
                                    Theme.of(context).textTheme.textMD.copyWith(
                                          color: AppColor.graymodern300,
                                        ),
                                h1: Theme.of(context).textTheme.textLG.copyWith(
                                      color: AppColor.graymodern100,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                h2: Theme.of(context).textTheme.textMD.copyWith(
                                      color: AppColor.graymodern100,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                h3: Theme.of(context).textTheme.textSM.copyWith(
                                      color: AppColor.graymodern100,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
