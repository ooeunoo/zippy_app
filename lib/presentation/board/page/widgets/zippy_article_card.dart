import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_icon_button.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_comment.dart';

class ZippyArticleCard extends GetView<BoardController> {
  final Article article;
  final Source? source;
  final bool isBookMarked;
  final Function(Article article) bookmarkArticle;
  final Function(Article article) shareArticle;
  final Function(Article article) commentArticle;
  final Function(Article article) reportArticle;
  final VoidCallback openMenu;

  const ZippyArticleCard({
    super.key,
    required this.source,
    required this.article,
    required this.isBookMarked,
    required this.bookmarkArticle,
    required this.shareArticle,
    required this.commentArticle,
    required this.reportArticle,
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
                  Row(
                    children: [
                      Container(
                        width: AppDimens.width(50),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(4),
                          vertical: AppDimens.height(4),
                        ),
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                              source?.contentType?.color ?? '0xff000000')),
                          borderRadius:
                              BorderRadius.circular(AppDimens.size(4)),
                        ),
                        child: AppText(
                          source?.contentType?.name ?? '',
                          style: Theme.of(context).textTheme.textXS.copyWith(
                                color: AppColor.white,
                              ),
                          align: TextAlign.center,
                        ),
                      ),
                      AppSpacerH(value: AppDimens.width(10)),
                      AppText(
                        article.published.timeAgo(),
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.graymodern400,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => bookmarkArticle(article),
                        icon: Icon(
                          Icons.bookmark,
                          color: isBookMarked ? AppColor.rose500 : null,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => showCommentBottomSheet(context, [
                          {
                            "userName": "사용자1",
                            "content":
                                "정말 좋은 내용이네요!,정말 좋은 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요! 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요",
                            "time": "10분 전"
                          },
                          {
                            "userName": "사용자2",
                            "content": "저도 같은 생각이에요.",
                            "time": "5분 전"
                          }
                        ]),
                        icon: const Icon(Icons.chat_bubble_outline),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: openMenu,
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacerV(value: AppDimens.height(20)),

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

              AppSpacerV(value: AppDimens.height(20)),
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

              AppSpacerV(value: AppDimens.height(10)),

              // 해시태그
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
