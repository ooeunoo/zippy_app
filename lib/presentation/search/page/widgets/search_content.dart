import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';
import 'package:zippy/presentation/search/page/widgets/feature_article_item.dart';

class SearchContent extends StatefulWidget {
  final List<Article> searchArticles;
  final TextEditingController searchController;
  final Function(Article) onHandleClickArticle;
  final Function() onLoadMore;
  final bool isLoading;
  final bool hasMoreData;

  const SearchContent({
    super.key,
    required this.searchArticles,
    required this.searchController,
    required this.onHandleClickArticle,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMoreData,
  });

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.isLoading && widget.hasMoreData) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final controller = Get.find<AppSearchController>();
        await controller.refreshSearch();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Featured Item Section
          if (widget.searchArticles.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppDimens.width(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeaturedArticleItem(
                      article: widget.searchArticles[0],
                      searchText: widget.searchController.text,
                      onHandleClickArticle: () =>
                          widget.onHandleClickArticle(widget.searchArticles[0]),
                    ),
                    AppSpacerV(value: AppDimens.height(24)),
                  ],
                ),
              ),
            ),

          // Regular Items List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Skip the first item as it's shown as featured
                final actualIndex = index + 1;

                if (actualIndex < widget.searchArticles.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.width(12),
                    ),
                    child: Column(
                      children: [
                        ArticleRowItem(
                          article: widget.searchArticles[actualIndex],
                          searchText: widget.searchController.text,
                          onHandleClickArticle: () =>
                              widget.onHandleClickArticle(
                                  widget.searchArticles[actualIndex]),
                        ),
                        AppSpacerV(value: AppDimens.height(4)),
                      ],
                    ),
                  );
                } else if (widget.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return null;
                }
              },
              childCount: widget.searchArticles.length > 1
                  ? (widget.searchArticles.length - 1) +
                      (widget.isLoading ? 1 : 0)
                  : 0,
            ),
          ),
        ],
      ),
    );
  }
}
