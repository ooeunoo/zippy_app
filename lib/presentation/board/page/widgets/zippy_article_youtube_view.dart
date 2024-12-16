import 'dart:math';

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
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_random_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleYoutubeView extends StatefulWidget {
  final Article article;

  const ZippyArticleYoutubeView({super.key, required this.article});

  @override
  State<ZippyArticleYoutubeView> createState() =>
      _ZippyArticleYoutubeViewState();
}

class _ZippyArticleYoutubeViewState extends State<ZippyArticleYoutubeView> {
  final articleService = Get.find<ArticleService>();
  bool isKeyPointsExpanded = false;
  final scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
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
            _buildMainImage(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacerV(value: AppDimens.height(8)),
                  _buildMetadataRow(context),
                  AppSpacerV(value: AppDimens.height(22)),

                  // Key Points Card
                  _buildKeyPointsCard(context),
                  AppSpacerV(value: AppDimens.height(24)),
                  const AppDivider(),
                  AppSpacerV(value: AppDimens.height(24)),

                  AppSpacerV(value: AppDimens.height(100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppHeaderWrap(
      child: AppHeader(
        title: Tooltip(
          message: widget.article.title,
          preferBelow: true,
          verticalOffset: AppDimens.height(24),
          margin: EdgeInsets.symmetric(
            horizontal: AppDimens.width(16),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(16),
            vertical: AppDimens.height(8),
          ),
          decoration: BoxDecoration(
            color: AppColor.graymodern800,
            borderRadius: BorderRadius.circular(AppDimens.radius(8)),
            border: Border.all(
              color: AppColor.graymodern700,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          textStyle: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.graymodern200,
                height: 1.5,
              ),
          waitDuration: const Duration(milliseconds: 500),
          showDuration: const Duration(seconds: 3),
          triggerMode: TooltipTriggerMode.tap,
          child: AppText(
            widget.article.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern100,
                  fontWeight: AppFontWeight.bold,
                  height: 1.4,
                ),
          ),
        ),
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

  Widget _buildMainImage() {
    List<String> allImages = List<String>.from(widget.article.images);
    List<String> allVideos = [];

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

    if (allImages.isEmpty && allVideos.isEmpty) {
      return SizedBox(
        height: AppDimens.height(200),
        width: double.infinity,
        child: AppRandomImage(id: widget.article.id.toString()),
      );
    }

    final List<String> allMedia = [...allImages, ...allVideos];

    return Stack(
      children: [
        SizedBox(
          height: AppDimens.height(200),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: allMedia.length,
            itemBuilder: (context, index) {
              final bool isVideo = index >= allImages.length;
              final String mediaUrl = allMedia[index];

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: mediaUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      AppRandomImage(id: widget.article.id.toString()),
                ),
              );
            },
          ),
        ),
        if (allMedia.length > 1)
          Positioned(
            bottom: AppDimens.height(8),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allMedia.length,
                (index) => Container(
                  width: AppDimens.width(8),
                  height: AppDimens.width(8),
                  margin: EdgeInsets.symmetric(horizontal: AppDimens.width(4)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColor.blue400
                        : AppColor.graymodern700,
                  ),
                ),
              ),
            ),
          ),
        // 이미지 개수 표시
        Positioned(
          bottom: AppDimens.height(8),
          right: AppDimens.width(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(8),
              vertical: AppDimens.height(4),
            ),
            decoration: BoxDecoration(
              color: AppColor.graymodern900.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppDimens.radius(4)),
            ),
            child: AppText(
              '${_currentPage + 1}/${allMedia.length}',
              style: Theme.of(context).textTheme.textXS.copyWith(
                    color: AppColor.graymodern200,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    final platform =
        articleService.getSourceById(widget.article.sourceId)?.platform;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.height(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(),
            // decoration: BoxDecoration(
            //   color: AppColor.blue500.withOpacity(0.2),
            //   borderRadius: BorderRadius.circular(AppDimens.radius(4)),
            // ),
            child: AppText(
              platform?.name ?? "",
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.graymodern300,
                    fontWeight: AppFontWeight.medium,
                  ),
            ),
          ),
          AppSpacerH(value: AppDimens.width(4)),
          AppText(
            '·',
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern300,
                ),
          ),
          AppSpacerH(value: AppDimens.width(4)),
          AppText(
            widget.article.published.timeAgo(),
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern300,
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
          color: AppColor.graymodern300,
        ),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          count,
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.graymodern300,
              ),
        ),
      ],
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
