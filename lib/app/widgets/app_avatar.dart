import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_loader.dart';
import 'package:zippy/app/widgets/app_svg.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  final int? rank;
  final double? rankSize;
  final Color? rankColor;
  final bool upload;

  const AppAvatar(
      {super.key,
      this.imageUrl,
      this.size,
      this.rank,
      this.rankSize,
      this.rankColor,
      this.upload = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (!upload) return;
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: size ?? AppDimens.width(40),
            height: size ?? AppDimens.height(40),
            decoration: BoxDecoration(
              color: AppColor.gray100,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.gray300,
                width: 0.75,
              ),
            ),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => const AppLoader(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors
                          .black, // Change to your desired foreground color
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AppSvg(Assets.user01, color: AppColor.gray600),
                  ),
          ),
        ),
        if (rank != null) // 등수가 있는 경우 뱃지를 표시
          Positioned(
            bottom: -AppDimens.height(8),
            right: -AppDimens.width(2),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: rankSize ?? AppDimens.width(8),
                  vertical: rankSize ?? AppDimens.height(8)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rankColor ?? AppColor.yellow400, // 배경색
                border: Border.all(
                  color: Colors.white, // 테두리 색상
                  width: AppDimens.width(2), // 테두리 두께
                ),
              ),
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColor.white, // 숫자 색상
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
