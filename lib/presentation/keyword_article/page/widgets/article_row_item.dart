import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';

class ArticleRowItem extends StatefulWidget {
  final Article article;
  final Function onHandleClickArticle;
  final String? searchText;
  final bool showContentType;

  const ArticleRowItem({
    super.key,
    required this.article,
    required this.onHandleClickArticle,
    this.searchText,
    this.showContentType = false,
  });

  @override
  State<ArticleRowItem> createState() => _ArticleRowItemState();
}

class _ArticleRowItemState extends State<ArticleRowItem> {
  final articleService = Get.find<ArticleService>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppThemeColors.isDarkMode(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppThemeColors.articleItemBoxBackgroundColor(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onHandleClickArticle(),
        child: SizedBox(
          height: AppDimens.height(Platform.isAndroid ? 100 : 90),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.width(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppCircleImage(
                      widget.article.images.isNotEmpty
                          ? widget.article.images[0]
                          : null,
                      size: AppDimens.size(40),
                    ),
                  ),
                ),
                AppSpacerH(value: AppDimens.width(12)),

                // Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AppText(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.textXS.copyWith(
                              color: AppThemeColors.textHighest(context),
                              fontWeight: AppFontWeight.semibold,
                            ),
                      ),
                      AppSpacerV(value: AppDimens.height(8)),

                      // Metadata Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetadata(context),
                          // Engagement Stats
                          // _buildEngagementStats(context),

                          // Timestamp
                          // Text(
                          //   widget.article.published.timeAgo(),
                          //   style: Theme.of(context).textTheme.textXS.copyWith(
                          //         color: AppThemeColors.textHigh(context),
                          //       ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    Source? source = articleService.getSourceById(widget.article.sourceId);
    return Row(
      children: [
        AppText(
          '${source?.platform?.name ?? ""} | ${widget.article.published.timeAgo()}',
          style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppThemeColors.textHigh(context),
              ),
        ),
      ],
    );
  }
}
