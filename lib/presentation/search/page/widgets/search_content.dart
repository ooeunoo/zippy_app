import 'package:flutter/material.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

class SearchContent extends StatelessWidget {
  final List<Article> searchArticles;
  final TextEditingController searchController;
  final Function(Article) onHandleClickArticle;

  const SearchContent({
    super.key,
    required this.searchArticles,
    required this.searchController,
    required this.onHandleClickArticle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: searchArticles.length,
      separatorBuilder: (context, index) =>
          AppSpacerV(value: AppDimens.height(20)),
      itemBuilder: (context, index) {
        return ArticleRowItem(
          article: searchArticles[index],
          searchText: searchController.text,
          onHandleClickArticle: () =>
              onHandleClickArticle(searchArticles[index]),
        );
      },
    );
  }
}
