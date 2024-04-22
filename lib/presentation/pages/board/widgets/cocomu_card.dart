import 'dart:ui';

import 'package:cocomu/app/utils/assets.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';
import 'package:cocomu/app/utils/styles/theme.dart';
import 'package:cocomu/app/widgets/app_shadow_overlay.dart';
import 'package:cocomu/app/widgets/app_spacer_h.dart';
import 'package:cocomu/app/widgets/app_spacer_v.dart';
import 'package:cocomu/app/widgets/app_svg.dart';
import 'package:cocomu/app/widgets/app_text.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;

class CocomuCard extends StatefulWidget {
  final Community community;
  final Item item;
  final bool isBookMarked;

  const CocomuCard(
      {super.key,
      required this.community,
      required this.item,
      required this.isBookMarked});

  @override
  State<CocomuCard> createState() => _CocomuCardState();
}

class _CocomuCardState extends State<CocomuCard> {
  late Future<void> _imageFuture;

  @override
  void didChangeDependencies() {
    print(widget.item.contentImgUrl);
    super.didChangeDependencies();
    _imageFuture =
        precacheImage(NetworkImage(widget.item.contentImgUrl ?? ""), context);
  }

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
    return FutureBuilder<void>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading image'));
        } else {
          if (widget.item.contentImgUrl == null) {
            return CachedNetworkImage(
              imageUrl: widget.item.contentImgUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black.withOpacity(0.5),
              ),
            );
          } else {
            return CachedNetworkImage(
              imageUrl: widget.item.contentImgUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black.withOpacity(0.5),
              ),
              imageBuilder: (context, imageProvider) => AppShadowOverlay(
                shadowColor: AppColor.graymodern950,
                child: Container(
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
      },
    );
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
                    child: CircleAvatar(
                      radius: AppDimens.size(16),
                      backgroundImage: AssetImage(widget.community.logo!),
                    ),
                  ),
                  AppSpacerH(value: AppDimens.width(10)),
                  SizedBox(
                    width: AppDimens.size(100),
                    child: AppText(
                      widget.item.author,
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
                    onTap: () {
                      print('bookmark');
                    },
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
                  widget.item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .textXL
                      .copyWith(color: AppColor.gray50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
