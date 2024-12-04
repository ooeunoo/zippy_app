import 'package:flutter/cupertino.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_ad_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_drawer.dart';

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
        handleClickBookmark: _controller.onHandleClickBookmark,
      ),
      appBar: _buildHeader(),
      body: Column(
        children: [
          _buildStoriesSection(),
          Expanded(
            child: _buildPageContent(),
          ),
        ],
      ),
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

  PreferredSizeWidget _buildHeader() {
    return AppHeaderWrap(
      child: AppHeader(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.size(20)),
          child: AppSvg(Assets.logo, size: AppDimens.size(50)),
        ),
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.size(12)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: AppColor.graymodern200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.size(12)),
      child: SizedBox(
        height: AppDimens.height(90),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _controller.articles.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(
                      _controller.articles[index].images[0] ?? '',
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            );
          },
        ),
      ),
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
