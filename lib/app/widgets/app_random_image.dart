import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_shadow_overlay.dart';
import 'package:zippy/app/widgets/app_text.dart';

class AppRandomImage extends StatelessWidget {
  final String id;

  const AppRandomImage({super.key, required this.id});

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
