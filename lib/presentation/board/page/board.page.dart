import 'package:flutter/cupertino.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_ad_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_card.dart';
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

  Future<void> _handleJumpToArticle(int articleId) async {
    int targetIndex = 0;
    bool found = false;

    for (int i = 0; i < _controller.articles.length; i++) {
      final article = _controller.articles[i];
      if (article.id == articleId) {
        targetIndex = i;
        found = true;
        break;
      }
    }

    if (!found) return;

    try {
      // animateToPage 대신 jumpToPage 사용
      _pageController.jumpToPage(targetIndex);

      // await Future.delayed(const Duration(milliseconds: 100));
      // if (mounted) {
      //   _pageController.animateTo(
      //     _pageController.position.pixels,
      //     duration: const Duration(milliseconds: 150),
      //     curve: Curves.easeOut,
      //   );
      // }
    } catch (e) {
      debugPrint('Error navigating to page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: _buildDrawerContent(),
      body: _buildPageContent(),
    );
  }

  Widget _buildDrawerContent() {
    return Drawer(
      backgroundColor: AppColor.graymodern950,
      child: SafeArea(
        child: Obx(() {
          // 광고를 제외한 실제 콘텐츠만 필터링
          final contentArticles =
              _controller.articles.where((article) => !article.isAd).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: contentArticles.length,
            itemBuilder: (context, index) =>
                _buildDrawerItem(context, contentArticles[index]),
          );
        }),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, Article article) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(10),
            vertical: AppDimens.height(10),
          ),
          child: ArticleRowItem(
            article: article,
            onHandleClickArticle: () {
              Navigator.of(context).pop();
              _handleJumpToArticle(article.id!);
            },
          ),
        ),
        const AppDivider(color: AppColor.graymodern900),
      ],
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
      child: ZippyArticleCard(
        article: article,
      ),
    );
  }
}
