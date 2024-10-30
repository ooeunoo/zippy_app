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

class _ZippyCardState extends State<ZippyArticleCard>
    with SingleTickerProviderStateMixin {
  Platform? get platform => widget.platform;
  Article get article => widget.article;
  bool get isBookmarked => widget.isBookMarked;
  Function(Article article) get toggleBookmark => widget.toggleBookmark;
  Function(Article article) get openMenu => widget.openMenu;

  List<Map<String, String>> comments = [
    {
      "userName": "사용자1",
      "content":
          "정말 좋은 내용이네요!,정말 좋은 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요! 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요 내용이네요!정말 좋은 내용이네요!정말 좋은 내용이네요",
      "time": "10분 전"
    },
    {"userName": "사용자2", "content": "저도 같은 생각이에요.", "time": "5분 전"}
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 50,
            child: imageSection(),
          ),
          Expanded(
            flex: 50,
            child: infoSection(),
          ),
        ],
      ),
    );
  }

  Widget imageSection() {
    print("image url: ${article.images[0]}");
    final size = MediaQuery.of(context).size;
    final imageWidth = size.width;
    final imageHeight = imageWidth * 0.6;

    if (article.images.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: article.images[0],
          fit: BoxFit.cover, // contain 대신 cover 사용
          filterQuality: FilterQuality.high, // none 대신 high 사용
          memCacheWidth: (imageWidth * 2).cacheSize(context), // 캐시 크기 2배 증가
          memCacheHeight: (imageHeight * 2).cacheSize(context), // 캐시 크기 2배 증가
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => Container(
            height: imageHeight, // placeholder 높이 지정
            color: AppColor.graymodern950.withOpacity(0.5),
          ),
          errorWidget: (context, url, error) => randomImageWidget(),
          imageBuilder: (context, imageProvider) => Container(
            height: imageHeight, // 컨테이너 높이 지정
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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
          Expanded(
            flex: 15, // 20에서 15로 줄임
            child: infoHeader(),
          ),
          Expanded(
            flex: 45, // 40에서 45로 늘림
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoTitle(),
                AppSpacerV(value: AppDimens.height(5)),
                infoSubContest(),
              ],
            ),
          ),
          if (comments.isNotEmpty) ...{
            Expanded(
              flex: 40,
              child: CommentSection(
                comments: comments,
                onTap: () => showCommentBottomSheet(context, comments),
              ),
            ),
          }
        ],
      ),
    );
  }

  Widget infoHeader() {
    return Column(
      children: [
        Row(
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
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                          ),
                        )
                      : const AppSvg(Assets.logo, color: AppColor.gray600),
                ),
                AppSpacerH(value: AppDimens.width(10)),
                SizedBox(
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
                    color: isBookmarked
                        ? AppColor.brand700
                        : AppColor.graymodern600,
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
        ),
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

  Widget infoSubContest() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: AppText(
            article.content,
            maxLines: 2, // 줄 수 제한
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .textSM
                .copyWith(color: AppColor.graymodern400),
          ),
        ),
      ],
    );
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
}

class CommentSection extends StatefulWidget {
  final List<Map<String, String>> comments;
  final Function() onTap;

  const CommentSection({
    Key? key,
    required this.comments,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _commentAnimationController;
  int currentCommentIndex = 0;
  bool isFirstDisplay = true;

  @override
  void initState() {
    super.initState();
    _commentAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    if (widget.comments.isNotEmpty) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          if (isFirstDisplay) {
            isFirstDisplay = false;
            return;
          }
          _commentAnimationController.forward(from: 0);
          setState(() {
            currentCommentIndex =
                (currentCommentIndex + 1) % widget.comments.length;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText("댓글",
                  style: Theme.of(context)
                      .textTheme
                      .textXL
                      .copyWith(color: AppColor.graymodern100)),
              AppText("더보기",
                  style: Theme.of(context)
                      .textTheme
                      .textSM
                      .copyWith(color: AppColor.graymodern400)),
            ],
          ),
          AppSpacerV(value: AppDimens.height(20)),
          if (isFirstDisplay) ...{
            CommentPreviewItem(
              userName: widget.comments[currentCommentIndex]["userName"]!,
              content: widget.comments[currentCommentIndex]["content"]!,
              time: widget.comments[currentCommentIndex]["time"]!,
            ),
          } else ...{
            FadeTransition(
              opacity: _commentAnimationController,
              child: CommentPreviewItem(
                userName: widget.comments[currentCommentIndex]["userName"]!,
                content: widget.comments[currentCommentIndex]["content"]!,
                time: widget.comments[currentCommentIndex]["time"]!,
              ),
            ),
          }
        ],
      ),
    );
  }
}

class CommentPreviewItem extends StatelessWidget {
  final String userName;
  final String content;
  final String time;

  const CommentPreviewItem({
    super.key,
    required this.userName,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColor.graymodern800,
          child: AppText(
            userName[0],
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern100,
                ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    userName,
                    style: Theme.of(context).textTheme.textSM.copyWith(
                          color: AppColor.graymodern100,
                        ),
                  ),
                  AppSpacerH(value: AppDimens.width(8)),
                  AppText(
                    time,
                    style: Theme.of(context).textTheme.textXS.copyWith(
                          color: AppColor.graymodern400,
                        ),
                  ),
                ],
              ),
              AppSpacerV(value: AppDimens.height(4)),
              AppText(
                content,
                maxLines: 2, // 최대 2줄로 제한
                overflow: TextOverflow.ellipsis, // 초과시 말줄임표 표시
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern200,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 바텀시트 관련 함수
void showCommentBottomSheet(
    BuildContext context, List<Map<String, String>> comments) {
  Get.bottomSheet(
    Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColor.graymodern950,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildBottomSheetHeader(context),
          _buildCommentList(context, comments),
          _buildCommentInput(context),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Widget _buildBottomSheetHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppDimens.width(20),
      vertical: AppDimens.height(15),
    ),
    decoration: const BoxDecoration(
      border:
          Border(bottom: BorderSide(color: AppColor.graymodern800, width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          "댓글",
          style: Theme.of(context).textTheme.text2XL.copyWith(
                color: AppColor.graymodern100,
              ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const AppSvg(Assets.message, color: AppColor.graymodern100),
        ),
      ],
    ),
  );
}

Widget _buildCommentList(
    BuildContext context, List<Map<String, String>> comments) {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: comments.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppDimens.height(15)),
        child: CommentPreviewItem(
          userName: comments[index]["userName"]!,
          content: comments[index]["content"]!,
          time: comments[index]["time"]!,
        ),
      ),
    ),
  );
}

Widget _buildCommentInput(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(AppDimens.width(20)),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColor.graymodern800, width: 1)),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.graymodern100,
                ),
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
              hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern400,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColor.graymodern800),
              ),
              filled: true,
              fillColor: AppColor.graymodern900,
            ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        IconButton(
          onPressed: () {
            // 댓글 작성 로직
          },
          icon: const AppSvg(Assets.message, color: AppColor.brand600),
        ),
      ],
    ),
  );
}
