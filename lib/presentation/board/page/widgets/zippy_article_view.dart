import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_random_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;

  const ZippyArticleView({Key? key, required this.article}) : super(key: key);

  @override
  _ZippyArticleViewState createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMainImage(),
            _buildMetadata(),
            _buildKeywords(),
            _buildSections(),
            _buildSummary(),
            _buildContent(),
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

  Widget _buildMetadata() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKeywords(),
          _buildEngagement(),
        ],
      ),
    );
  }

  Widget _buildKeywords() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.article.keywords
            .map((keyword) => Container(
                  decoration: BoxDecoration(
                    color: AppColor.graymodern400,
                    borderRadius: BorderRadius.circular(AppDimens.size(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppText('#$keyword',
                        style: Theme.of(context)
                            .textTheme
                            .textXS
                            .copyWith(color: AppColor.graymodern200)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildEngagement() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(widget.article.author),
            AppSpacerH(value: AppDimens.width(8)),
            Text(widget.article.published.toString()),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.remove_red_eye, size: 16),
            AppSpacerH(value: AppDimens.width(4)),
            Text(widget.article.metadata?.viewCount.toString() ?? '0'),
            AppSpacerH(value: AppDimens.width(16)),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 16),
                  AppSpacerH(value: AppDimens.width(4)),
                  Text(widget.article.metadata?.commentCount.toString() ?? '0'),
                ],
              ),
            ),
            AppSpacerH(value: AppDimens.width(16)),
            const Icon(Icons.share, size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark)),
      ],
    );
  }

  Widget _buildSections() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('목차',
              style: Theme.of(context)
                  .textTheme
                  .textXL
                  .copyWith(fontWeight: FontWeight.bold)),
          AppSpacerV(value: AppDimens.height(16)),
          ...widget.article.sections.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  section.title,
                  style: Theme.of(context)
                      .textTheme
                      .textLG
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                AppSpacerV(value: AppDimens.height(8)),
                ...section.content.map((content) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(content),
                    )),
                AppSpacerV(value: AppDimens.height(16)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      margin: EdgeInsets.all(AppDimens.width(16)),
      padding: EdgeInsets.all(AppDimens.width(16)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('요약',
              style: Theme.of(context)
                  .textTheme
                  .textXL
                  .copyWith(fontWeight: FontWeight.bold)),
          AppSpacerV(value: AppDimens.height(12)),
          Text(widget.article.summary),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('본문',
              style: Theme.of(context)
                  .textTheme
                  .textXL
                  .copyWith(fontWeight: FontWeight.bold)),
          AppSpacerV(value: AppDimens.height(12)),
          AppText(widget.article.summary,
              style: Theme.of(context).textTheme.textLG),
        ],
      ),
    );
  }
}
