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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacerV(value: AppDimens.height(4)),
            _buildMainImage(),
            AppSpacerV(value: AppDimens.height(18)),
            _buildMetadata(context),
            AppSpacerV(value: AppDimens.height(24)),
            _buildKeyPoints(context),
            AppSpacerV(value: AppDimens.height(24)),
            _buildContent(context),
            AppSpacerV(value: AppDimens.height(24)),
            // _buildAuthorInfo(context),
            // AppSpacerV(value: AppDimens.height(32)),
          ],
        ),
      ),
    );
  }

  AppHeader _buildAppBar(BuildContext context) {
    return AppHeader(
      title: AppText(
        widget.article.title,
        maxLines: 1,
        style: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.graymodern300, fontWeight: AppFontWeight.semibold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColor.graymodern200),
          onPressed: () =>
              articleService.onHandleArticleSupportMenu(widget.article),
        ),
      ],
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

  Widget _buildMetadata(BuildContext context) {
    final platform =
        articleService.getSourceById(widget.article.sourceId)?.platform;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppText(
                platform?.name ?? "",
                style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.graymodern400,
                    fontWeight: AppFontWeight.medium),
              ),
              AppSpacerH(value: AppDimens.width(8)),
              AppText(
                '·',
                style: Theme.of(context)
                    .textTheme
                    .textSM
                    .copyWith(color: AppColor.graymodern400),
              ),
              AppSpacerH(value: AppDimens.width(8)),
              AppText(
                widget.article.published.timeAgo(),
                style: Theme.of(context)
                    .textTheme
                    .textSM
                    .copyWith(color: AppColor.graymodern400),
              ),
            ],
          ),
          Row(children: [
            _buildMetadataItem(
              context,
              Icons.remove_red_eye,
              widget.article.metadata?.viewCount.toString() ?? '0',
            ),
            AppSpacerH(value: AppDimens.width(16)),
            _buildMetadataItem(
              context,
              Icons.thumb_up_outlined,
              widget.article.metadata?.likeCount.toString() ?? '0',
            ),
            AppSpacerH(value: AppDimens.width(16)),
            _buildMetadataItem(
              context,
              Icons.chat_bubble_outline,
              widget.article.metadata?.commentCount.toString() ?? '0',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: AppDimens.size(16), color: AppColor.graymodern400),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          count,
          style: Theme.of(context)
              .textTheme
              .textSM
              .copyWith(color: AppColor.graymodern400),
        ),
      ],
    );
  }

  Widget _buildKeyPoints(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      padding: EdgeInsets.all(AppDimens.width(16)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.circular(AppDimens.radius(8)),
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
                AppText(
                  '주요 포인트',
                  style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern300,
                      fontWeight: AppFontWeight.semibold),
                ),
                Icon(
                  isKeyPointsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.graymodern300,
                ),
              ],
            ),
          ),
          if (isKeyPointsExpanded) ...[
            AppSpacerV(value: AppDimens.height(12)),
            ...widget.article.keyPoints.map((point) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.height(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: AppDimens.height(8)),
                        width: AppDimens.width(4),
                        height: AppDimens.width(4),
                        decoration: const BoxDecoration(
                          color: AppColor.graymodern200,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacerH(value: AppDimens.width(8)),
                      Expanded(
                        child: AppText(
                          point,
                          style: Theme.of(context).textTheme.textMD.copyWith(
                              color: AppColor.blue400,
                              height: AppDimens.height(1.5)),
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

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.article.sections.map((section) {
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: AppText(
                  section.title,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                      fontWeight: AppFontWeight.semibold,
                      color: AppColor.graymodern200),
                ),
                children: section.content
                    .map((content) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.width(16),
                            vertical: AppDimens.height(8),
                          ),
                          child: MarkdownBody(
                            data: '> $content',
                            styleSheet: MarkdownStyleSheet(
                              p: Theme.of(context).textTheme.textSM.copyWith(
                                    color: AppColor.graymodern400,
                                  ),
                              strong:
                                  Theme.of(context).textTheme.textSM.copyWith(
                                        color: AppColor.graymodern400,
                                        fontWeight: AppFontWeight.bold,
                                      ),
                              blockquoteDecoration: BoxDecoration(
                                color: AppColor.graymodern900,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              blockquotePadding: EdgeInsets.symmetric(
                                horizontal: AppDimens.width(16),
                                vertical: AppDimens.height(12),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColor.graymodern800,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    widget.article.author,
                    style: Theme.of(context).textTheme.textSM.copyWith(
                        color: AppColor.graymodern600,
                        fontWeight: AppFontWeight.medium),
                  ),
                ],
              ),
            ],
          ),
          AppButton(
            '원문 보기',
            onPressed: () =>
                articleService.onHandleOpenOriginalArticle(widget.article),
            borderColor: AppColor.transparent,
            color: AppColor.transparent,
            width: AppDimens.width(70),
            titleStyle: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.brand400, fontWeight: AppFontWeight.medium),
          ),
        ],
      ),
    );
  }
}
