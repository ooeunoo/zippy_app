import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class FeaturedArticleItem extends StatelessWidget {
  final Article article;
  final Function onHandleClickArticle;
  final String? searchText;

  const FeaturedArticleItem({
    super.key,
    required this.article,
    required this.onHandleClickArticle,
    this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppThemeColors.articleItemBoxBackgroundColor(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onHandleClickArticle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: AppDimens.height(160),
                child: article.images.isNotEmpty
                    ? Image.network(
                        article.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppThemeColors.articleItemBoxBackgroundColor(
                                context),
                            child: Icon(
                              Icons.image_not_supported,
                              size: AppDimens.size(40),
                              color: AppThemeColors.iconColor(context),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppThemeColors.articleItemBoxBackgroundColor(
                            context),
                        child: Icon(
                          Icons.article,
                          size: AppDimens.size(40),
                          color: AppThemeColors.iconColor(context),
                        ),
                      ),
              ),
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(AppDimens.width(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  AppText(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.textLG.copyWith(
                          color: AppThemeColors.textHighest(context),
                          fontWeight: AppFontWeight.semibold,
                        ),
                  ),
                  AppSpacerV(value: AppDimens.height(12)),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildEngagementStats(context),
                      Text(
                        article.published.timeAgo(),
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppThemeColors.textHigh(context),
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
    );
  }

  Widget _buildEngagementStats(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          context,
          Icons.remove_red_eye_outlined,
          article.metadata?.viewCount.toString() ?? '0',
        ),
        AppSpacerH(value: AppDimens.width(16)),
        _buildStatItem(
          context,
          Icons.chat_bubble_outline,
          article.metadata?.commentCount.toString() ?? '0',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.size(18),
          color: AppThemeColors.iconColor(context),
        ),
        AppSpacerH(value: AppDimens.width(4)),
        Text(
          count,
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppThemeColors.textHigh(context),
              ),
        ),
      ],
    );
  }
}
