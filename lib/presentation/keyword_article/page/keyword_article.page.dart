import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';
import 'package:zippy/presentation/search/page/widgets/rank_content.dart';
import 'package:zippy/presentation/search/page/widgets/search_content.dart';

class KeywordArticlesPage extends StatefulWidget {
  const KeywordArticlesPage({super.key});

  @override
  State<KeywordArticlesPage> createState() => _KeywordArticlesPageState();
}

class _KeywordArticlesPageState extends State<KeywordArticlesPage> {
  final AppSearchController controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSearchBar = false;
  Timer? _debounce; // 추가

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // 추가
    super.dispose();
  }

  void _handleSearch(String keyword) {
    setState(() {
      _showSearchBar = true;
      _searchController.text = keyword;
    });

    controller.onHandleFetchArticlesBySearch(keyword);
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.isEmpty) {
      controller.searchArticles.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        controller.onHandleFetchArticlesBySearch(value, refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          // Column 추가
          children: [
            Expanded(
              // Expanded를 Column 내부로 이동
              child: _showSearchBar
                  ? Obx(() => SearchContent(
                        searchArticles: controller.searchArticles,
                        searchController: _searchController,
                        onHandleClickArticle: controller.onHandleClickArticle,
                        onLoadMore: () =>
                            controller.onHandleFetchArticlesBySearch(
                                _searchController.text),
                        isLoading: controller.isLoading.value,
                        hasMoreData: controller.hasMoreData.value,
                      ))
                  : RankContent(
                      onKeywordTap: _handleSearch,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppHeaderWrap(
      child: _showSearchBar ? _buildSearchAppBar() : _buildRankAppBar(),
    );
  }

  AppHeader _buildSearchAppBar() {
    return AppHeader(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () {
            setState(() {
              _showSearchBar = false;
              controller.searchArticles.clear(); // 검색 결과 초기화 추가
            });
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
                setState(() {
                  _showSearchBar = false;
                });
              } else {
                _searchController.clear();
                controller.searchArticles.clear(); // 검색 결과 초기화 추가
              }
            },
          ),
        ),
      ],
    );
  }

  AppHeader _buildRankAppBar() {
    return AppHeader(
      title: AppText(
        '실시간 순위',
        style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppThemeColors.textHighest(context),
            fontWeight: AppFontWeight.medium),
      ),
      noLeading: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppDimens.width(12)),
          child: IconButton(
            onPressed: () {
              setState(() {
                _showSearchBar = true;
                _focusNode.requestFocus();
              });
            },
            icon: Icon(Icons.search, color: AppThemeColors.iconColor(context)),
          ),
        ),
      ],
    );
  }
}
