import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
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
  final Function(Article article) onHandleBookmarkArticle;
  final Function(Article article) onHandleShareArticle;
  final VoidCallback openMenu;

  const ZippyArticleCard({
    super.key,
    required this.source,
    required this.article,
    required this.isBookMarked,
    required this.onHandleBookmarkArticle,
    required this.onHandleShareArticle,
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
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () => onHandleBookmarkArticle(article),
                        icon: Icon(
                          Icons.bookmark,
                          color: isBookMarked ? AppColor.brand600 : null,
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () => showCommentBottomSheet(
                                context,
                                article.id!,
                                controller.onHandleGetArticleComments,
                                controller.onHandleCreateArticleComment),
                            icon: const Icon(Icons.chat_bubble_outline),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColor.brand600,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: AppText(
                                '2',
                                style:
                                    Theme.of(context).textTheme.textXS.copyWith(
                                          color: AppColor.white,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: openMenu,
                        icon: const Icon(Icons.more_vert),
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

              AppSpacerV(value: AppDimens.height(20)),

              // 요약
              AppText(
                article.summary ?? '',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern400,
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),

              AppSpacerV(value: AppDimens.height(20)),
              // SizedBox(
              //   height: AppDimens.height(28), // 태그의 높이에 맞게 조정
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: article.keywords?.length ?? 0,
              //     itemBuilder: (context, index) {
              //       final tag = article.keywords![index];
              //       return Padding(
              //         padding: EdgeInsets.only(right: AppDimens.width(4)),
              //         child: Container(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: AppDimens.width(12),
              //             vertical: AppDimens.height(2),
              //           ),
              //           decoration: BoxDecoration(
              //             color: AppColor.graymodern300,
              //             borderRadius:
              //                 BorderRadius.circular(AppDimens.size(16)),
              //           ),
              //           child: Center(
              //             child: AppText(
              //               '#$tag',
              //               style: Theme.of(context).textTheme.textXS.copyWith(
              //                     color: AppColor.graymodern600,
              //                   ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),

              // AppSpacerV(value: AppDimens.height(10)),

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
