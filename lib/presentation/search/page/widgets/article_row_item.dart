import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ArticleRowItem extends StatelessWidget {
  final Article article;
  final Function onHandleClickArticle;
  final String? searchText;

  const ArticleRowItem({
    super.key,
    required this.article,
    required this.onHandleClickArticle,
    this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onHandleClickArticle(),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppDimens.height(2)),
            child: AppCircleImage(article.images[0]),
          ),
          AppSpacerH(value: AppDimens.width(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedTitle(context, article.title, searchText ?? '',
                    article.title.toLowerCase()),
                AppSpacerV(value: AppDimens.height(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEngagementStats(context),
                    AppText(
                      article.published.timeAgo(),
                      style: Theme.of(context).textTheme.textXS.copyWith(
                            color: AppColor.gray400,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedTitle(BuildContext context, String title,
      String searchText, String titleLower) {
    if (searchText.isEmpty || !titleLower.contains(searchText)) {
      return AppText(
        title,
        maxLines: 2,
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: Colors.white,
              fontWeight: AppFontWeight.medium,
            ),
      );
    }

    final beforeText = title.substring(0, titleLower.indexOf(searchText));
    final matchText = title.substring(titleLower.indexOf(searchText),
        titleLower.indexOf(searchText) + searchText.length);
    final afterText =
        title.substring(titleLower.indexOf(searchText) + searchText.length);

    return RichText(
      maxLines: 2,
      text: TextSpan(
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: Colors.white,
              fontWeight: AppFontWeight.medium,
            ),
        children: [
          TextSpan(text: beforeText),
          TextSpan(
            text: matchText,
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.blue400,
                  fontWeight: AppFontWeight.medium,
                ),
          ),
          TextSpan(text: afterText),
        ],
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
        AppSpacerH(value: AppDimens.width(12)),
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
          color: AppColor.graymodern400,
        ),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          count,
          style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppColor.graymodern400,
              ),
        ),
      ],
    );
  }
}
