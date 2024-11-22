import 'package:flutter/cupertino.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_ad_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_drawer.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late final BoardController _controller;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<BoardController>();
    _pageController =
        PageController(initialPage: _controller.currentPage.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleJumpToArticle(int index) async {
    if (!(index >= 0 && index < _controller.articles.length)) return;

    try {
      _pageController.jumpToPage(index);
    } catch (e) {
      debugPrint('Error navigating to page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: ZippyArticleDrawer(
        articles: _controller.articles,
        handleJumpToArticle: _handleJumpToArticle,
        handleFetchArticles: _controller.onHandleFetchRecommendedArticles,
      ),
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return GetX<BoardController>(
      builder: (controller) {
        if (controller.isLoadingContents.value) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColor.brand600,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColor.brand600,
          backgroundColor: AppColor.graymodern950,
          displacement: 50,
          strokeWidth: 3,
          onRefresh: controller.onHandleFetchRecommendedArticles,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            dragStartBehavior: DragStartBehavior.start,
            controller: _pageController,
            onPageChanged: controller.onHandleChangedArticle,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: controller.articles.length,
            itemBuilder: _buildPageItem,
          ),
        );
      },
    );
  }

  Widget _buildPageItem(BuildContext context, int index) {
    final article = _controller.articles[index];

    if (article.isAd) {
      return ZippyAdArticleCard(adArticle: article as AdArticle);
    }

    return GestureDetector(
      onTap: () => _controller.onHandleClickArticle(article),
      behavior: HitTestBehavior.opaque,
      child: ZippyArticleCard(
        article: article,
      ),
    );
  }
}
