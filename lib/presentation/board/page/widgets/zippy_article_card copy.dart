import 'dart:async';

import 'package:get/get.dart';
import 'package:zippy/app/extensions/num.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_loader.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ZippyArticleCard extends StatelessWidget {
  final Platform? platform;
  final Article article;
  final bool isBookMarked;
  final Function(Article article) toggleBookmark;
  final Function(Article article) openMenu;

  const ZippyArticleCard({
    super.key,
    required this.platform,
    required this.article,
    required this.isBookMarked,
    required this.toggleBookmark,
    required this.openMenu,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 50,
            child: _ImageSection(article: article),
          ),
          Expanded(
            flex: 30,
            child: _InfoSection(
              platform: platform,
              article: article,
              isBookMarked: isBookMarked,
              toggleBookmark: toggleBookmark,
              openMenu: openMenu,
            ),
          ),
          Expanded(
            flex: 10,
            child: _HashTagSection(article: article),
          ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final Article article;

  const _ImageSection({required this.article});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageWidth = size.width;
    final imageHeight = imageWidth * 0.6;

    if (article.images.isNotEmpty) {
      return _NetworkImageWidget(
        imageUrl: article.images[0],
        imageWidth: imageWidth,
        imageHeight: imageHeight,
      );
    }

    return _RandomImageWidget(
      articleId: article.id.toString(),
    );
  }
}

class _NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double imageWidth;
  final double imageHeight;

  const _NetworkImageWidget({
    required this.imageUrl,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        memCacheWidth: (imageWidth * 2).cacheSize(context),
        memCacheHeight: (imageHeight * 2).cacheSize(context),
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => Container(
          height: imageHeight,
          color: AppColor.graymodern950.withOpacity(0.5),
        ),
        errorWidget: (context, url, error) => _RandomImageWidget(
          articleId: '',
        ),
        imageBuilder: (context, imageProvider) => Container(
          height: imageHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _RandomImageWidget extends StatelessWidget {
  final String articleId;

  const _RandomImageWidget({required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppShadowOverlay(
          shadowColor: AppColor.graymodern950,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(Assets.randomImage(articleId)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AppText(
            "해당 이미지는 콘텐츠와 관련없습니다",
            style: Theme.of(context)
                .textTheme
                .textSM
                .copyWith(color: AppColor.graymodern100),
          ),
        )
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Platform? platform;
  final Article article;
  final bool isBookMarked;
  final Function(Article) toggleBookmark;
  final Function(Article) openMenu;

  const _InfoSection({
    required this.platform,
    required this.article,
    required this.isBookMarked,
    required this.toggleBookmark,
    required this.openMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(25),
        vertical: AppDimens.height(20),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 15,
            child: _InfoHeader(
              platform: platform,
              article: article,
              isBookMarked: isBookMarked,
              toggleBookmark: toggleBookmark,
              openMenu: openMenu,
            ),
          ),
          Expanded(
            flex: 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoTitle(title: article.title),
                AppSpacerV(value: AppDimens.height(5)),
                _InfoContent(content: article.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 타입, 시간
// 타이틀
// 해시 태그
class _InfoHeader extends StatelessWidget {
  final Platform? platform;
  final Article article;
  final bool isBookMarked;
  final Function(Article) toggleBookmark;
  final Function(Article) openMenu;

  const _InfoHeader({
    required this.platform,
    required this.article,
    required this.isBookMarked,
    required this.toggleBookmark,
    required this.openMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PlatformInfo(platform: platform),
        _ActionButtons(
          article: article,
          isBookMarked: isBookMarked,
          toggleBookmark: toggleBookmark,
          openMenu: openMenu,
        ),
      ],
    );
  }
}

class _PlatformInfo extends StatelessWidget {
  final Platform? platform;

  const _PlatformInfo({required this.platform});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: AppDimens.size(24),
          width: AppDimens.size(24),
          child: platform?.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: platform!.imageUrl!,
                  placeholder: (context, url) => const AppLoader(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                  ),
                )
              : const AppSvg(Assets.logo, color: AppColor.gray600),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        AppText(
          platform?.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .textMD
              .copyWith(color: AppColor.gray50),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Article article;
  final bool isBookMarked;
  final Function(Article) toggleBookmark;
  final Function(Article) openMenu;

  const _ActionButtons({
    required this.article,
    required this.isBookMarked,
    required this.toggleBookmark,
    required this.openMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => openMenu(article),
          child: AppSvg(
            Assets.dotsVertical,
            size: AppDimens.size(23),
            color: AppColor.graymodern600,
          ),
        ),
      ],
    );
  }
}

class _InfoTitle extends StatelessWidget {
  final String title;

  const _InfoTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppText(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style:
          Theme.of(context).textTheme.text2XL.copyWith(color: AppColor.gray50),
    );
  }
}

class _InfoContent extends StatelessWidget {
  final String content;

  const _InfoContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return AppText(
      content,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .textSM
          .copyWith(color: AppColor.graymodern400),
    );
  }
}

class _HashTagSection extends StatelessWidget {
  final Article article;

  const _HashTagSection({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(25)),
      height: AppDimens.height(60),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: AppDimens.width(5),
        runSpacing: AppDimens.height(5),
        children: [
          ...article.keywords?.map((tag) => _HashTag(tag: tag)).toList() ?? [],
        ],
      ),
    );
  }
}

class _HashTag extends StatelessWidget {
  final String tag;

  const _HashTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(10),
        vertical: AppDimens.height(5),
      ),
      decoration: BoxDecoration(
        color: AppColor.graymodern600,
        borderRadius: BorderRadius.circular(AppDimens.size(10)),
      ),
      child: AppText(
        '#$tag',
        style: Theme.of(context)
            .textTheme
            .textXS
            .copyWith(color: AppColor.graymodern100),
      ),
    );
  }
}
