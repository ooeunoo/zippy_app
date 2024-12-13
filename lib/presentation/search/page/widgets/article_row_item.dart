import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
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
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimens.width(12),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColor.graymodern900,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onHandleClickArticle(),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.width(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AppCircleImage(
                    article.images.isNotEmpty ? article.images[0] : null,
                    size: AppDimens.size(40), // Reduced from 80
                  ),
                ),
              ),
              SizedBox(width: AppDimens.width(12)),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: AppDimens.height(8)),

                    // Metadata Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Engagement Stats
                        _buildEngagementStats(context),

                        // Timestamp
                        Text(
                          article.published.timeAgo(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.graymodern500,
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
        SizedBox(width: AppDimens.width(12)),

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
          size: AppDimens.size(14),
          color: AppColor.graymodern500,
        ),
        SizedBox(width: AppDimens.width(4)),
        Text(
          count,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.graymodern500,
              ),
        ),
      ],
    );
  }
}
