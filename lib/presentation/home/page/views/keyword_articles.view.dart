import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_shimmer.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';
import 'package:zippy/presentation/search/page/widgets/feature_article_item.dart';

class KeywordArticlesView extends StatefulWidget {
  final String keyword;
  final List<Article> articles;

  const KeywordArticlesView({
    super.key,
    required this.keyword,
    required this.articles,
  });

  @override
  State<KeywordArticlesView> createState() => _KeywordArticlesViewState();
}

class _KeywordArticlesViewState extends State<KeywordArticlesView> {
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
          () {
            // 초기 로딩 상태일 때 중앙에 로딩 표시
            if (homeController.isInitLoading.value) {
              return _buildLoadingShimmer();
            }

            return CustomScrollView(
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
                        // 추가 페이지 로딩 시 AppShimmer 표시
                        return _buildLoadingShimmer();
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(12),
            vertical: AppDimens.height(6),
          ),
          child: Card(
            color: AppThemeColors.articleItemBoxBackgroundColor(context),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: AppDimens.height(100),
              padding: EdgeInsets.all(AppDimens.width(12)),
              child: Row(
                children: [
                  AppShimmer(
                    width: AppDimens.width(40),
                    height: AppDimens.width(40),
                    radius: 10,
                  ),
                  AppSpacerH(value: AppDimens.width(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppShimmer(
                          width: double.infinity,
                          height: AppDimens.height(16),
                          radius: 4,
                        ),
                        AppSpacerV(value: AppDimens.height(8)),
                        AppShimmer(
                          width: AppDimens.width(120),
                          height: AppDimens.height(12),
                          radius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
      title: AppText(
        widget.keyword,
        style: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.gray100, fontWeight: AppFontWeight.medium),
      ), // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: AppDimens.width(12)),
      //     child: IconButton(
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //       icon: Icon(
      //         Icons.clear,
      //         color: AppThemeColors.iconColor(context),
      //       ),
      //       onPressed: () {
      //         if (_searchController.text.isEmpty) {
      //         } else {
      //           _searchController.clear();
      //           homeController.searchArticles.clear(); // 검색 결과 초기화 추가
      //         }
      //       },
      //     ),
      //   ),
      // ],
    );
  }
}
