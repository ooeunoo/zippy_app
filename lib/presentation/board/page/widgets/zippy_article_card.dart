import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_random_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_comment.dart';

class ZippyArticleCard extends StatelessWidget {
  final Article article;
  final Source? source;
  final bool isBookMarked;
  final Function(Article) onHandleBookmarkArticle;
  final Function(Article) onHandleShareArticle;
  final Future<List<ArticleComment>> Function(int) onHandleGetArticleComments;
  final Future<void> Function(CreateArticleCommentParams)
      onHandleCreateArticleComment;
  final VoidCallback openMenu;

  const ZippyArticleCard({
    super.key,
    required this.source,
    required this.article,
    required this.isBookMarked,
    required this.onHandleBookmarkArticle,
    required this.onHandleShareArticle,
    required this.onHandleGetArticleComments,
    required this.onHandleCreateArticleComment,
    required this.openMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildImageSection(context),
        AppSpacerV(value: AppDimens.height(8)),
        _buildContentSection(context),
        AppSpacerV(value: AppDimens.height(20)),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMainImage(),
            _buildContentTypeLabel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    return article.images.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: article.images[0],
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColor.graymodern950.withOpacity(0.5),
            ),
            errorWidget: (context, url, error) => AppRandomImage(
              id: article.id.toString(),
            ),
          )
        : AppRandomImage(id: article.id.toString());
  }

  Widget _buildContentTypeLabel(BuildContext context) {
    return Positioned(
      top: AppDimens.height(70),
      right: AppDimens.width(20),
      child: Container(
        width: AppDimens.width(50),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(4),
          vertical: AppDimens.height(4),
        ),
        decoration: BoxDecoration(
          color: Color(int.parse(source?.contentType?.color ?? '0xff000000'))
              .withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppDimens.size(4)),
        ),
        child: AppText(
          source?.contentType?.name ?? '',
          style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppColor.white,
              ),
          align: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlatformLabel(BuildContext context) {
    return Positioned(
      top: AppDimens.height(70),
      left: AppDimens.width(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(4),
          vertical: AppDimens.height(4),
        ),
        decoration: BoxDecoration(
          color: AppColor.graymodern950.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppDimens.size(4)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(4),
          ),
          child: AppText(
            source?.platform?.name ?? '',
            style: Theme.of(context).textTheme.textXS.copyWith(
                  color: AppColor.white,
                ),
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetadataRow(context),
          AppSpacerV(value: AppDimens.height(10)),
          _buildTitle(context),
          AppSpacerV(value: AppDimens.height(20)),
          _buildSummary(context),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildPlatformAndAuthorAndTime(context),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildPlatformAndAuthorAndTime(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: AppDimens.width(80),
            ),
            child: AppText(
              source?.platform?.name ?? '',
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.graymodern400,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(8)),
        AppText(
          '·',
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.graymodern400,
              ),
        ),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          article.published.timeAgo(),
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.graymodern400,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => onHandleBookmarkArticle(article),
          icon: Icon(
            Icons.bookmark,
            color: isBookMarked ? AppColor.brand600 : null,
          ),
        ),
        _buildCommentButton(context),
        IconButton(
          padding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: openMenu,
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => showCommentBottomSheet(context, article.id!,
              onHandleGetArticleComments, onHandleCreateArticleComment),
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        if ((article.metadata?.commentCount ?? 0) > 0)
          _buildCommentCount(context),
      ],
    );
  }

  Widget _buildCommentCount(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: AppColor.brand600,
          borderRadius: BorderRadius.circular(18),
        ),
        child: AppText(
          article.metadata?.commentCount.toString() ?? '0',
          style: Theme.of(context).textTheme.textXS.copyWith(
                color: AppColor.white,
              ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AppText(
      article.title,
      style: Theme.of(context).textTheme.text2XL.copyWith(
            color: AppColor.graymodern50,
            fontWeight: FontWeight.w600,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSummary(BuildContext context) {
    return AppText(
      article.summary ?? '',
      style: Theme.of(context).textTheme.textSM.copyWith(
            color: AppColor.graymodern400,
            height: 1.6,
            letterSpacing: 0.5,
          ),
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
    );
  }
}
