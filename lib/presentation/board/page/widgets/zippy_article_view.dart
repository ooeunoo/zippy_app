import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_random_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;

  const ZippyArticleView({super.key, required this.article});

  @override
  _ZippyArticleViewState createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMainImage(),
            AppSpacerV(value: AppDimens.height(16)),
            _buildEngagement(),
            AppSpacerV(value: AppDimens.height(14)),
            _buildKeywords(),
            AppSpacerV(value: AppDimens.height(16)),
            _buildSummary(),
            AppSpacerV(value: AppDimens.height(16)),
            _buildSections(),
            AppSpacerV(value: AppDimens.height(100)),
          ],
        ),
      ),
    );
  }

  AppHeader _buildAppBar() {
    return AppHeader(
      title: AppText(
        widget.article.title,
        maxLines: 1,
        style: Theme.of(context).textTheme.textSM.copyWith(
            color: AppColor.graymodern200, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMainImage() {
    return widget.article.images.isNotEmpty
        ? SizedBox(
            height: AppDimens.height(200),
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: widget.article.images[0],
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => AppRandomImage(
                id: widget.article.id.toString(),
              ),
            ),
          )
        : SizedBox(
            height: AppDimens.height(200),
            width: double.infinity,
            child: AppRandomImage(id: widget.article.id.toString()));
  }

  Widget _buildEngagement() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppText(widget.article.author,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern400,
                      fontWeight: FontWeight.w500)),
              AppSpacerH(value: AppDimens.width(4)),
              AppText("·",
                  style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern400,
                      fontWeight: FontWeight.w500)),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(widget.article.published.timeAgo(),
                  style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern400,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.remove_red_eye,
                  size: 16, color: AppColor.graymodern400),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(widget.article.metadata?.viewCount.toString() ?? '0',
                  style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern400,
                      fontWeight: FontWeight.w500)),
              AppSpacerH(value: AppDimens.width(16)),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 16, color: AppColor.graymodern400),
                    AppSpacerH(value: AppDimens.width(4)),
                    AppText(
                        widget.article.metadata?.commentCount.toString() ?? '0',
                        style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppColor.graymodern400,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeywords() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.article.keywords
              .map((keyword) => Padding(
                    padding: EdgeInsets.only(right: AppDimens.width(8)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.graymodern800,
                        borderRadius: BorderRadius.circular(AppDimens.size(4)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.width(8),
                            vertical: AppDimens.height(4)),
                        child: AppText(keyword,
                            style: Theme.of(context)
                                .textTheme
                                .textXS
                                .copyWith(color: AppColor.graymodern200)),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppDimens.width(8), vertical: AppDimens.height(8)),
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16), vertical: AppDimens.height(12)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTabIndex = 0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: AppDimens.height(8)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTabIndex == 0
                              ? AppColor.brand600
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: AppText(
                      '키포인트',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                          fontWeight: AppFontWeight.semibold,
                          color: selectedTabIndex == 0
                              ? AppColor.brand600
                              : AppColor.graymodern500),
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTabIndex = 1),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: AppDimens.height(8)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTabIndex == 1
                              ? AppColor.brand600
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: AppText(
                      '요약',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                          fontWeight: AppFontWeight.semibold,
                          color: selectedTabIndex == 1
                              ? AppColor.brand600
                              : AppColor.graymodern500),
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacerV(value: AppDimens.height(12)),
          if (selectedTabIndex == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.article.keyPoints
                  .map((keypoint) => Padding(
                        padding: EdgeInsets.only(bottom: AppDimens.height(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              '• ',
                              style: Theme.of(context)
                                  .textTheme
                                  .textSM
                                  .copyWith(
                                      color: AppColor.graymodern200,
                                      height: AppDimens.height(1.6)),
                            ),
                            Expanded(
                              child: AppText(
                                keypoint,
                                style: Theme.of(context)
                                    .textTheme
                                    .textSM
                                    .copyWith(
                                        color: AppColor.graymodern200,
                                        height: AppDimens.height(1.6)),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            )
          else
            AppText(
              widget.article.summary,
              style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern200, height: AppDimens.height(1.6)),
            ),
        ],
      ),
    );
  }

  Widget _buildSections() {
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
                          child: AppText(
                            '> $content',
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: AppColor.graymodern400,
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
}
