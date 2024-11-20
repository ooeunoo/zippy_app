import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/ad_article.model.dart';

class ZippyAdArticleCard extends StatefulWidget {
  final AdArticle adArticle;

  const ZippyAdArticleCard({super.key, required this.adArticle});

  @override
  State<ZippyAdArticleCard> createState() => _ZippyAdArticleCardState();
}

class _ZippyAdArticleCardState extends State<ZippyAdArticleCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // _buildImageSection(context),
        AppSpacerV(value: AppDimens.height(8)),
        // _buildContentSection(context),
        AppSpacerV(value: AppDimens.height(20)),
      ],
    );
  }

  // Widget _buildImageSection(BuildContext context) {
  //   return AspectRatio(
  //     aspectRatio: 1,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.zero,
  //       child: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           AdImageView(ad: widget.adArticle.nativeAd),
  //           _buildAdLabel(context),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAdLabel(BuildContext context) {
  //   return Positioned(
  //     top: AppDimens.height(10),
  //     left: AppDimens.width(10),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: AppDimens.width(8),
  //         vertical: AppDimens.height(4),
  //       ),
  //       decoration: BoxDecoration(
  //         color: AppColor.graymodern800.withOpacity(0.7),
  //         borderRadius: BorderRadius.circular(AppDimens.size(4)),
  //       ),
  //       child: AppText(
  //         '광고',
  //         style: Theme.of(context).textTheme.textXS.copyWith(
  //               color: AppColor.white,
  //             ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildContentSection(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: AppDimens.width(12)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildMetadataRow(context),
  //         AppSpacerV(value: AppDimens.height(10)),
  //         _buildTitle(context),
  //         AppSpacerV(value: AppDimens.height(20)),
  //         _buildBody(context),
  //         AppSpacerV(value: AppDimens.height(12)),
  //         _buildCallToAction(context),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMetadataRow(BuildContext context) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: AdAdvertiserView(
  //           ad: widget.adArticle.nativeAd,
  //           style: Theme.of(context).textTheme.textSM.copyWith(
  //                 color: AppColor.graymodern600,
  //               ),
  //         ),
  //       ),
  //       AppSpacerH(value: AppDimens.width(8)),
  //       AppText(
  //         '·',
  //         style: Theme.of(context).textTheme.textSM.copyWith(
  //               color: AppColor.graymodern400,
  //             ),
  //       ),
  //       AppSpacerH(value: AppDimens.width(4)),
  //       AppText(
  //         'Sponsored',
  //         style: Theme.of(context).textTheme.textSM.copyWith(
  //               color: AppColor.graymodern600,
  //             ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTitle(BuildContext context) {
  //   return AdHeadlineView(
  //     ad: widget.adArticle.nativeAd,
  //     style: Theme.of(context).textTheme.text2XL.copyWith(
  //           color: AppColor.graymodern50,
  //           fontWeight: FontWeight.w600,
  //         ),
  //     maxLines: 2,
  //     overflow: TextOverflow.ellipsis,
  //   );
  // }

  // Widget _buildBody(BuildContext context) {
  //   return AdBodyView(
  //     ad: widget.adArticle.nativeAd,
  //     style: Theme.of(context).textTheme.textSM.copyWith(
  //           color: AppColor.graymodern400,
  //           height: 1.6,
  //           letterSpacing: 0.5,
  //         ),
  //     maxLines: 6,
  //     overflow: TextOverflow.ellipsis,
  //   );
  // }

  // Widget _buildCallToAction(BuildContext context) {
  //   return AdCallToActionView(
  //     ad: widget.adArticle.nativeAd,
  //     style: Theme.of(context).textTheme.textMD.copyWith(
  //           color: AppColor.white,
  //           fontWeight: FontWeight.w600,
  //         ),
  //     buttonStyle: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all(AppColor.brand600),
  //       padding: MaterialStateProperty.all(EdgeInsets.symmetric(
  //         horizontal: AppDimens.width(16),
  //         vertical: AppDimens.height(8),
  //       )),
  //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(AppDimens.radius(4)),
  //       )),
  //     ),
  //   );
  // }
}
