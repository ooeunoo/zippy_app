import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/domain/model/article.model.dart';

class ArticleRowItem extends StatelessWidget {
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
        onTap: () => onHandleClickArticle(),
        child: SizedBox(
          height: AppDimens.height(90),
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
                      article.images.isNotEmpty ? article.images[0] : null,
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
                      Text(
                        article.title,
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
                          // Engagement Stats
                          _buildEngagementStats(context),

                          // Timestamp
                          Text(
                            article.published.timeAgo(),
                            style: Theme.of(context).textTheme.textXXS.copyWith(
                                  color: AppThemeColors.textLow(context),
                                ),
                          ),
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

  Widget _buildEngagementStats(BuildContext context) {
    return Row(
      children: [
        // View Count
        _buildStatItem(
          context,
          Icons.remove_red_eye_outlined,
          article.metadata?.viewCount.toString() ?? '0',
        ),
        AppSpacerH(value: AppDimens.width(12)),

        // Like Count
        _buildStatItem(
          context,
          Icons.thumb_up_outlined,
          article.metadata?.likeCount.toString() ?? '0',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.size(12),
          color: AppThemeColors.iconColor(context),
        ),
        AppSpacerH(value: AppDimens.width(4)),
        Text(
          count,
          style: Theme.of(context).textTheme.textXXS.copyWith(
                color: AppThemeColors.textLow(context),
              ),
        ),
      ],
    );
  }
}
