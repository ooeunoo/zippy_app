import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/platform.model.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 이미지 섹션
        AspectRatio(
          aspectRatio: 1, // 정사각형 비율
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: article.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: article.images[0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColor.graymodern950.withOpacity(0.5),
                    ),
                    errorWidget: (context, url, error) => _RandomImageWidget(
                      id: article.id.toString(),
                    ),
                  )
                : _RandomImageWidget(id: article.id.toString()),
          ),
        ),

        AppSpacerV(value: AppDimens.height(20)),

        // 컨텐츠 섹션
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.width(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리와 시간
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.width(4),
                        vertical: AppDimens.height(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.rose500,
                        borderRadius: BorderRadius.circular(AppDimens.size(4)),
                      ),
                      child: AppText(
                        '스포츠',
                        // article.source.content_type.name,
                        style: Theme.of(context).textTheme.textXS.copyWith(
                              color: AppColor.white,
                            ),
                      ),
                    ),
                    AppSpacerH(value: AppDimens.width(10)),
                    AppText(
                      article.published.timeAgo(),
                      style: Theme.of(context).textTheme.textXS.copyWith(
                            color: AppColor.graymodern400,
                          ),
                    ),
                  ]),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.bookmark),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.comment),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacerV(value: AppDimens.height(10)),
              // 제목
              AppText(
                article.title,
                style: Theme.of(context).textTheme.text2XL.copyWith(
                      color: AppColor.graymodern50,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              AppSpacerV(value: AppDimens.height(5)),

              // 요약
              AppText(
                article.summary ?? '',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern200,
                      // fontWeight: FontWeight.w600,
                    ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),

              AppSpacerV(value: AppDimens.width(20)),

              // 해시태그
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: article.keywords?.map((tag) {
                        return Padding(
                          padding: EdgeInsets.only(right: AppDimens.width(4)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.width(12),
                              vertical: AppDimens.height(4),
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.graymodern500,
                              borderRadius:
                                  BorderRadius.circular(AppDimens.size(16)),
                            ),
                            child: AppText(
                              '# $tag',
                              style:
                                  Theme.of(context).textTheme.textXS.copyWith(
                                        color: AppColor.graymodern200,
                                      ),
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ],
          ),
        ),

        AppSpacerV(value: AppDimens.height(20)),
      ],
    );
  }
}

class _RandomImageWidget extends StatelessWidget {
  final String id;

  const _RandomImageWidget({required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppShadowOverlay(
          shadowColor: AppColor.graymodern950,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(Assets.randomImage(id)),
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
