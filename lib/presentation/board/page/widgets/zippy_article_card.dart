import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/format.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleCard extends StatelessWidget {
  final Article article;

  const ZippyArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    print(article.id);
    return SizedBox(
      height: MediaQuery.of(context).size.width * 2,
      child: Stack(
        children: [
          _buildMainImage(),
          _buildTopTag(context),
          _buildBookmarkButton(),
          _buildBottomContent(context),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    return Positioned.fill(
      child: article.images.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: article.images[0],
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
      color: AppColor.gray900,
      child: const Icon(
        Icons.image,
        color: AppColor.gray400,
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: AppColor.gray900,
      child: const Icon(
        Icons.error,
        color: AppColor.gray400,
      ),
    );
  }

  Widget _buildTopTag(BuildContext context) {
    return Positioned(
      top: AppDimens.height(16),
      left: AppDimens.width(16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(12),
          vertical: AppDimens.height(6),
        ),
        decoration: BoxDecoration(
          color: AppColor.graymodern400,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              '테크',
              style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppColor.white,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return Positioned(
      top: AppDimens.height(16),
      right: AppDimens.width(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(AppDimens.width(8)),
          child: const Icon(
            Icons.bookmark_border_rounded,
            color: AppColor.white,
            size: 24,
            shadows: [
              Shadow(
                color: AppColor.black,
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Positioned(
      left: AppDimens.width(0),
      right: AppDimens.width(0),
      bottom: AppDimens.height(0),
      child: Container(
        padding: EdgeInsets.all(AppDimens.width(16)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.95),
            ],
            stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            const SizedBox(height: 8),
            _buildSummary(context),
            const SizedBox(height: 16),
            _buildInteractionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AppText(
      article.title,
      style: Theme.of(context).textTheme.displayXS.copyWith(
        color: AppColor.graymodern50,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(0, 1),
            blurRadius: 3.0,
            color: Colors.black.withOpacity(0.8),
          ),
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 6.0,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSummary(BuildContext context) {
    return AppText(
      cleanMarkdownText(article.excerpt),
      style: Theme.of(context).textTheme.textSM.copyWith(
        color: AppColor.graymodern200,
        fontSize: 14,
        shadows: [
          Shadow(
            offset: Offset(0, 1),
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInteractionBar(BuildContext context) {
    return Row(
      children: [
        _buildInteractionItem(
          icon: Icons.favorite_border,
          text: '1200',
          context: context,
        ),
        AppSpacerH(value: AppDimens.width(16)),
        _buildInteractionItem(
          icon: Icons.chat_bubble_outline,
          text: '324',
          context: context,
        ),
        AppSpacerH(value: AppDimens.width(16)),
        const Icon(Icons.share, color: AppColor.white, size: 20),
        const Spacer(),
        AppText(
          '2.5만 조회',
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.white,
              ),
        ),
      ],
    );
  }

  Widget _buildInteractionItem({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColor.white, size: 20),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          text,
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.white,
              ),
        ),
      ],
    );
  }
}
