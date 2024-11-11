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

class SearchContent extends StatelessWidget {
  final List<Article> searchResults;
  final TextEditingController searchController;
  final Function(Article) onHandleClickArticle;

  const SearchContent({
    super.key,
    required this.searchResults,
    required this.searchController,
    required this.onHandleClickArticle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: searchResults.length,
      separatorBuilder: (context, index) =>
          AppSpacerV(value: AppDimens.height(20)),
      itemBuilder: (context, index) {
        return _buildSearchItem(context, searchResults[index]);
      },
    );
  }

  Widget _buildSearchItem(BuildContext context, Article article) {
    final searchText = searchController.text.toLowerCase();
    final titleLower = article.title.toLowerCase();

    return GestureDetector(
      onTap: () => onHandleClickArticle(article),
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
                _buildHighlightedTitle(context, article.title, searchText,
                    article.title.toLowerCase()),
                AppSpacerV(value: AppDimens.height(8)),
                AppText(
                  article.published.timeAgo(),
                  style: Theme.of(context).textTheme.textXS.copyWith(
                        color: AppColor.gray400,
                      ),
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
}
