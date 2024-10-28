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

class ZippyArticleCard extends StatefulWidget {
  final Platform? platform;
  final Article article;
  final bool isBookMarked;
  final Function(Article article) toggleBookmark;
  final Function(Article article) openMenu;

  const ZippyArticleCard(
      {super.key,
      required this.platform,
      required this.article,
      required this.isBookMarked,
      required this.toggleBookmark,
      required this.openMenu});

  @override
  State<ZippyArticleCard> createState() => _ZippyCardState();
}

class _ZippyCardState extends State<ZippyArticleCard> {
  Platform? get platform => widget.platform;
  Article get article => widget.article;
  bool get isBookmarked => widget.isBookMarked;
  Function(Article article) get toggleBookmark => widget.toggleBookmark;
  Function(Article article) get openMenu => widget.openMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///////////////////////
          // 이미지
          ///////////////////////
          Expanded(
            flex: 3,
            child: imageSection(),
          ),
          ///////////////////////
          // 커뮤니티 정보
          ///////////////////////
          Expanded(
            flex: 3,
            child: infoSection(),
          ),
        ],
      ),
    );
  }

  Widget imageSection() {
    if (article.images.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: article.images[0],
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColor.graymodern950.withOpacity(0.5),
        ),
        errorWidget: (context, url, error) => randomImageWidget(),
        imageBuilder: (context, imageProvider) => imageWidget(imageProvider),
      );
    } else {
      return randomImageWidget();
    }
  }

  Widget infoSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(25), vertical: AppDimens.height(20)),
      child: Column(
        children: [
          infoHeader(),
          const AppSpacerV(),
          infoTitle(),
          const AppSpacerV(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  article.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .textSM
                      .copyWith(color: AppColor.graymodern400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                      ),
                    )
                  : const AppSvg(Assets.logo, color: AppColor.gray600),
            ),
            AppSpacerH(value: AppDimens.width(10)),
            SizedBox(
              width: AppDimens.size(100),
              child: AppText(
                platform?.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .textMD
                    .copyWith(color: AppColor.gray50),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => toggleBookmark(article),
              child: AppSvg(
                Assets.bookmark,
                size: AppDimens.size(23),
                color:
                    isBookmarked ? AppColor.brand700 : AppColor.graymodern600,
              ),
            ),
            const AppSpacerH(),
            GestureDetector(
              onTap: () => openMenu(article),
              child: AppSvg(
                Assets.dotsVertical,
                size: AppDimens.size(23),
                color: AppColor.graymodern600,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget infoTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: AppText(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .text2XL
                .copyWith(color: AppColor.gray50),
          ),
        ),
      ],
    );
  }

  Widget infoComments() {
    return const Row();
  }

  Widget imageWidget(ImageProvider provider) {
    return Stack(
      children: [
        AppShadowOverlay(
          shadowColor: AppColor.graymodern950,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: provider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget randomImageWidget() {
    return Stack(
      children: [
        AppShadowOverlay(
          shadowColor: AppColor.graymodern950,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(Assets.randomImage(article.id.toString())),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AppText("해당 이미지는 콘텐츠와 관련없습니다",
              style: Theme.of(context)
                  .textTheme
                  .textSM
                  .copyWith(color: AppColor.graymodern100)),
        )
      ],
    );
  }

  // Widget dropdownMenu() {}
}
