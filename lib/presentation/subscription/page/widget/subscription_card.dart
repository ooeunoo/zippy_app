import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

class SubscriptionCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final bool isSubscribe;

  const SubscriptionCard({
    Key? key,
    required this.image,
    required this.name,
    required this.description,
    required this.isSubscribe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16), vertical: AppDimens.height(16)),
      decoration: BoxDecoration(
        color: isSubscribe ? AppColor.graymodern800 : AppColor.graymodern900,
        borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        border: isSubscribe
            ? Border.all(color: AppColor.graymodern600, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.network(
              //     image,
              //     width: 48,
              //     height: 48,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              AppSpacerH(value: AppDimens.width(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          name,
                          style: Theme.of(context).textTheme.textLG.copyWith(
                                color: AppColor.graymodern100,
                                fontWeight: AppFontWeight.bold,
                              ),
                        ),
                        if (isSubscribe) ...[
                          AppSpacerH(value: AppDimens.width(8)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.width(8),
                                vertical: AppDimens.height(2)),
                            decoration: BoxDecoration(
                              color: AppColor.graymodern700,
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radius(4)),
                            ),
                            child: AppText(
                              "구독중",
                              style:
                                  Theme.of(context).textTheme.textXS.copyWith(
                                        color: AppColor.graymodern300,
                                      ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacerV(value: AppDimens.height(4)),
                    AppText(
                      description,
                      style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppColor.graymodern400,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
