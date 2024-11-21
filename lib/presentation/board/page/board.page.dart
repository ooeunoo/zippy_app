import 'package:flutter/cupertino.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/article.service.dart';
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
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  AdmobService admobService = Get.find();
  ArticleService articleService = Get.find();
  late BoardController controller;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BoardController>();
    _pageController = PageController(initialPage: controller.currentPage.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleJumpToArticle(int index) async {
    if (index < 0 || index >= controller.articles.length) return;

    try {
      await _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      debugPrint('Error navigating to page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: AppColor.graymodern950,
        child: SafeArea(
          child: Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  Article article = controller.articles[index];

                  if (article.isAd) {
                    return const SizedBox.shrink();
                  }

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
                            _handleJumpToArticle(index);
                          },
                        ),
                      ),
                      if (index != controller.articles.length - 1)
                        const AppDivider(color: AppColor.graymodern900),
                    ],
                  );
                },
              )),
        ),
      ),
      body: GetX<BoardController>(
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
            onRefresh: () async {
              await controller.onHandleFetchRecommendedArticles();
            },
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
              itemBuilder: (context, index) {
                final article = controller.articles[index];

                if (article.isAd) {
                  return ZippyAdArticleCard(adArticle: article as AdArticle);
                }

                return GestureDetector(
                  onTap: () => controller.onHandleClickArticle(article),
                  child: ZippyArticleCard(
                    article: article,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
