import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';
import 'package:zippy/presentation/search/page/widgets/feature_article_item.dart';

class SearchView extends StatefulWidget {
  final String? keyword;

  const SearchView({
    super.key,
    this.keyword,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ArticleService articleService = Get.find();
  final HomeController homeController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce; // 추가

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    if (widget.keyword != null) {
      _searchController.text = widget.keyword!;
      _onSearchChanged(widget.keyword!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel(); // 추가
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!homeController.isSearchLoading.value &&
          homeController.hasMoreSearchData.value) {
        homeController.onHandleFetchArticlesBySearch(
          homeController.currentQuery.value,
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.isEmpty) {
      homeController.searchArticles.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        homeController.onHandleFetchArticlesBySearch(value, refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWrap(child: _buildAppBar()),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<AppSearchController>();
          await controller.refreshSearch();
        },
        child: Obx(
          () => CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Featured Item Section
              if (homeController.searchArticles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.width(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeaturedArticleItem(
                          article: homeController.searchArticles[0],
                          searchText: homeController.currentQuery.value,
                          onHandleClickArticle: () =>
                              articleService.onHandleOpenOriginalArticle(
                                  homeController.searchArticles[0]),
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

                    if (actualIndex < homeController.searchArticles.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(12),
                        ),
                        child: Column(
                          children: [
                            ArticleRowItem(
                              article:
                                  homeController.searchArticles[actualIndex],
                              searchText: homeController.currentQuery.value,
                              onHandleClickArticle: () => articleService
                                  .onHandleOpenOriginalArticle(homeController
                                      .searchArticles[actualIndex]),
                            ),
                            AppSpacerV(value: AppDimens.height(4)),
                          ],
                        ),
                      );
                    } else if (homeController.isSearchLoading.value) {
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
                  childCount: homeController.searchArticles.length > 1
                      ? (homeController.searchArticles.length - 1) +
                          (homeController.isSearchLoading.value ? 1 : 0)
                      : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppHeader _buildAppBar() {
    return AppHeader(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon:
              Icon(Icons.arrow_back, color: AppThemeColors.iconColor(context)),
        ),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        cursorHeight: AppDimens.height(18),
        style: Theme.of(context)
            .textTheme
            .textSM
            .copyWith(color: AppThemeColors.textHigh(context)),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          hintStyle: Theme.of(context)
              .textTheme
              .textSM
              .copyWith(color: AppThemeColors.textLowest(context)),
          border: InputBorder.none,
        ),
        onChanged: _onSearchChanged, // 변경
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppDimens.width(12)),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.clear,
              color: AppThemeColors.iconColor(context),
            ),
            onPressed: () {
              if (_searchController.text.isEmpty) {
              } else {
                _searchController.clear();
                homeController.searchArticles.clear(); // 검색 결과 초기화 추가
              }
            },
          ),
        ),
      ],
    );
  }
}
