import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/format.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleCard extends StatefulWidget {
  final Article article;

  const ZippyArticleCard({
    super.key,
    required this.article,
  });

  @override
  State<ZippyArticleCard> createState() => _ZippyArticleCardState();
}

class _ZippyArticleCardState extends State<ZippyArticleCard> {
  final ArticleService articleService = Get.find();
  final BookmarkService bookmarkService = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 2,
      child: Stack(
        children: [
          _buildMainImage(),
          _buildBottomContent(context),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    return Positioned.fill(
      child: widget.article.images.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.article.images[0],
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildPlaceholderImage(),
              errorWidget: (context, url, error) => _buildErrorImage(),
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppThemeColors.background(context),
      child: Icon(
        Icons.image,
        color: AppThemeColors.iconColor(context),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: AppThemeColors.background(context),
      child: Icon(
        Icons.error,
        color: AppThemeColors.iconColor(context),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    final isDark = AppThemeColors.isDarkMode(context);
    final baseColor = isDark ? AppColor.graymodern950 : AppColor.graymodern100;

    return Positioned(
      left: AppDimens.width(0),
      right: AppDimens.width(0),
      bottom: AppDimens.height(0),
      top: MediaQuery.of(context).size.width * 0.98,
      child: Container(
        padding: EdgeInsets.only(
          left: AppDimens.width(16),
          right: AppDimens.width(16),
          bottom: AppDimens.height(16),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              baseColor.withOpacity(0.05),
              baseColor.withOpacity(0.1),
              baseColor.withOpacity(0.15),
              baseColor.withOpacity(0.2),
              baseColor.withOpacity(0.25),
              baseColor.withOpacity(0.3),
              baseColor.withOpacity(0.35),
              baseColor.withOpacity(0.4),
              baseColor.withOpacity(0.45),
              baseColor.withOpacity(0.5),
              baseColor.withOpacity(0.55),
              baseColor.withOpacity(0.6),
              baseColor.withOpacity(0.65),
              baseColor.withOpacity(0.7),
              baseColor.withOpacity(0.75),
              baseColor.withOpacity(0.8),
              baseColor.withOpacity(0.85),
              baseColor.withOpacity(0.9),
              baseColor.withOpacity(0.95),
              baseColor.withOpacity(0.98),
            ],
            stops: const [
              0.0,
              0.05,
              0.1,
              0.15,
              0.2,
              0.25,
              0.3,
              0.35,
              0.4,
              0.45,
              0.5,
              0.55,
              0.6,
              0.65,
              0.7,
              0.75,
              0.8,
              0.85,
              0.9,
              0.95,
              1.0
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            AppSpacerV(value: AppDimens.height(8)),
            _buildSummary(context),
            AppSpacerV(value: AppDimens.height(16)),
            _buildPublishedDate(context),
            AppSpacerV(value: AppDimens.height(16)),
            _buildInteractionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isDark = AppThemeColors.isDarkMode(context);
    final baseColor = isDark ? AppColor.graymodern950 : AppColor.graymodern50;

    return AppText(
      widget.article.title,
      style: Theme.of(context).textTheme.text2XL.copyWith(
        color: AppThemeColors.textHighest(context),
        fontWeight: AppFontWeight.bold,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 3.0,
            color: baseColor.withOpacity(0.2),
          ),
          Shadow(
            offset: const Offset(0, 2),
            blurRadius: 6.0,
            color: baseColor.withOpacity(0.2),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSummary(BuildContext context) {
    final isDark = AppThemeColors.isDarkMode(context);
    final baseColor = isDark ? AppColor.graymodern950 : AppColor.graymodern50;

    return AppText(
      cleanMarkdownText(widget.article.excerpt),
      style: Theme.of(context).textTheme.textSM.copyWith(
        color: AppThemeColors.textHighest(context),
        height: 1.5,
        letterSpacing: -0.3,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 2.0,
            color: baseColor.withOpacity(0.6),
          ),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPublishedDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppText(
          widget.article.published.timeAgo(),
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppThemeColors.textLow(context),
              ),
        ),
      ],
    );
  }

  Widget _buildInteractionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          _buildInteractionItem(
            icon: Icons.remove_red_eye_outlined,
            text: widget.article.metadata?.viewCount.toString() ?? '0',
            context: context,
          ),
          AppSpacerH(value: AppDimens.width(16)),
          _buildInteractionItem(
            icon: Icons.chat_bubble_outline,
            text: widget.article.metadata?.commentCount.toString() ?? '0',
            context: context,
            onTap: () {
              articleService.onHandleShowArticleComment(widget.article);
            },
          ),
        ]),
        Row(children: [
          _buildActionItem(
            icon: Icons.share,
            color: AppThemeColors.iconColor(context),
            context: context,
            onTap: () {
              articleService.onHandleShareArticle(widget.article);
            },
          ),
          Obx(() {
            final isBookmarked =
                bookmarkService.isBookmarked(widget.article.id!) != null;

            return _buildActionItem(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked
                    ? AppThemeColors.bookmarkedIconColor(context)
                    : AppThemeColors.iconColor(context),
                context: context,
                onTap: () {
                  articleService.onHandleBookmarkArticle(widget.article);
                });

            // return IconButton(
            //   icon: isBookmarked
            //       ? Icon(Icons.bookmark,
            //           color: AppThemeColors.bookmarkedIconColor(context),
            //           size: AppDimens.size(24))
            //       : Icon(Icons.bookmark_border,
            //           color: AppThemeColors.iconColor(context),
            //           size: AppDimens.size(24)),
            //   onPressed: () {
            //     articleService.onHandleBookmarkArticle(widget.article);
            //   },
            // );
          }),
        ]),
      ],
    );
  }

  Widget _buildInteractionItem({
    required IconData icon,
    required String text,
    required BuildContext context,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
              color: AppThemeColors.iconColor(context),
              size: AppDimens.size(24)),
          AppSpacerH(value: AppDimens.width(4)),
          AppText(
            text,
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppThemeColors.textMedium(context),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    required BuildContext context,
    Function()? onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: AppDimens.size(24)),
      onPressed: onTap,
    );
  }
}
