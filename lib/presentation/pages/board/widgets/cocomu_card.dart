import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ZippyCard extends StatefulWidget {
  final Channel? channel;
  final Item item;
  final bool isBookMarked;
  final Function(int id) toggleBookmark;

  const ZippyCard(
      {super.key,
      required this.channel,
      required this.item,
      required this.isBookMarked,
      required this.toggleBookmark});

  @override
  State<ZippyCard> createState() => _ZippyCardState();
}

class _ZippyCardState extends State<ZippyCard> {
  late Future<void> _imageFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageFuture =
        precacheImage(NetworkImage(widget.item.contentImgUrl ?? ""), context);
  }

  void toogleBookmark() {
    int? itemId = widget.item.id;
    if (itemId != null) {
      widget.toggleBookmark(itemId);
    }
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
          return CachedNetworkImage(
            imageUrl: widget.item.contentImgUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.black.withOpacity(0.5),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Text("error"),
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
                      backgroundImage: widget.channel?.logo != null
                          ? AssetImage(widget.channel!.logo!)
                          : null,
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
