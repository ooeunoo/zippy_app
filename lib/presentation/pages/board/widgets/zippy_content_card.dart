import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/validate.dart';
import 'package:zippy/app/widgets/app_loader.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ZippyContentCard extends StatefulWidget {
  final Channel? channel;
  final Content content;
  final bool isBookMarked;
  final Function(Content content) toggleBookmark;

  const ZippyContentCard(
      {super.key,
      required this.channel,
      required this.content,
      required this.isBookMarked,
      required this.toggleBookmark});

  @override
  State<ZippyContentCard> createState() => _ZippyCardState();
}

class _ZippyCardState extends State<ZippyContentCard> {
  void toogleBookmark() {
    widget.toggleBookmark(widget.content);
  }

  bool get isUrl =>
      widget.content.contentImgUrl != null &&
      isValidUrl(widget.content.contentImgUrl!);

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
            flex: 6,
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
    if (widget.content.contentImgUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.content.contentImgUrl!,
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
                    child: widget.channel?.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.channel!.imageUrl!,
                            placeholder: (context, url) => const AppLoader(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors
                                  .black, // Change to your desired foreground color
                            ),
                          )
                        : const AppSvg(Assets.logo, color: AppColor.gray600),
                  ),
                  AppSpacerH(value: AppDimens.width(10)),
                  SizedBox(
                    width: AppDimens.size(100),
                    child: AppText(
                      widget.content.author == ""
                          ? widget.channel!.nameKo
                          : widget.content.author,
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
                    onTap: toogleBookmark,
                    child: AppSvg(
                      Assets.bookmark,
                      size: AppDimens.size(23),
                      color: widget.isBookMarked
                          ? AppColor.rose500
                          : AppColor.graymodern600,
                    ),
                  )
                ],
              )
            ],
          ),
          const AppSpacerV(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  widget.content.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .text2XL
                      .copyWith(color: AppColor.gray50),
                ),
              ),
            ],
          ),
        ],
      ),
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
                image: NetworkImage(
                    Assets.randomImage(widget.content.id.toString())),
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
