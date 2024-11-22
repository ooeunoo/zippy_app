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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AppSearchController controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
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
    controller.onHandleFetchArticlesByKeyword(keyword);
  }

  // 검색 디바운스 처리
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.isEmpty) {
      controller.searchArticles.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        controller.onHandleFetchArticlesBySearch(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _showSearchBar
            ? Obx(() => SearchContent(
                  searchArticles: controller.searchArticles.value,
                  searchController: _searchController,
                  onHandleClickArticle: controller.onHandleClickArticle,
                ))
            : Obx(
                () => RankContent(
                  trendingKeywords: controller.trendingKeywords.value,
                  onKeywordTap: _handleSearch,
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return _showSearchBar ? _buildSearchAppBar() : _buildRankAppBar();
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.gray100),
        onPressed: () {
          setState(() {
            _showSearchBar = false;
            controller.searchArticles.clear(); // 검색 결과 초기화 추가
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        style: Theme.of(context)
            .textTheme
            .textSM
            .copyWith(color: AppColor.gray100),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          hintStyle: Theme.of(context)
              .textTheme
              .textSM
              .copyWith(color: AppColor.gray400),
          border: InputBorder.none,
        ),
        autofocus: true,
        onChanged: _onSearchChanged, // 변경
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear, color: AppColor.gray100),
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
      ],
    );
  }

  AppHeader _buildRankAppBar() {
    return AppHeader(
      title: AppText(
        '실시간 순위',
        style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.gray100, fontWeight: AppFontWeight.medium),
      ),
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppDimens.width(12)),
          child: IconButton(
            onPressed: () {
              setState(() {
                _showSearchBar = true;
              });
            },
            icon: const Icon(Icons.search, color: AppColor.gray100),
          ),
        ),
      ],
    );
  }
}
