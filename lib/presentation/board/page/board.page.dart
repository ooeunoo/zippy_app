import 'package:flutter/cupertino.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/ad_article.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_ad_article_card.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_card.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({
    super.key,
  });

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  AdmobService admobService = Get.find();
  ArticleService articleService = Get.find();

  // @override
  // void initState() {
  //   super.initState();

  //   admobService.loadBannerAd();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    BoardController controller = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: AppColor.graymodern950,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 아티클 리스트
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      Article article = controller.articles[index];
                      if (!article.isAd) {
                        return Column(
                          children: [
                            ListTile(
                              title: AppText(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.textSM.copyWith(
                                          color: AppColor.graymodern100,
                                        ),
                              ),
                              subtitle: AppText(
                                "",
                                style:
                                    Theme.of(context).textTheme.textXS.copyWith(
                                          color: AppColor.graymodern400,
                                        ),
                              ),
                              onTap: () {
                                controller.onHandleJumpToArticle(index);
                                Navigator.pop(context);
                              },
                            ),
                            const Divider(
                              // 각 ListTile 아래에 Divider 추가
                              height: 1,
                              thickness: 1,
                              color: AppColor.graymodern900,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )),
              const Divider(color: AppColor.graymodern800),
              // ListTile(
              //   leading:
              //       const AppSvg(Assets.logo, color: AppColor.graymodern100),
              //   title: AppText(
              //     "구독 채널 추가하기",
              //     style: Theme.of(context).textTheme.textMD.copyWith(
              //           color: AppColor.graymodern100,
              //         ),
              //   ),
              //   onTap: () {
              //     Get.toNamed(Routes.subscription);
              //   },
              // ),
            ],
          ),
        ),
      ),
      body: GetX<BoardController>(
        // GetX를 사용하여 컨트롤러 상태 관찰
        builder: (controller) {
          if (controller.isLoadingContents.value) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: AppColor.brand600,
              ),
            );
          }

          return Obx(() => RefreshIndicator(
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
                    controller: controller.pageController,
                    onPageChanged: controller.onHandleChangedArticle,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          final article = controller.articles[index];

                          if (article.isAd) {
                            return ZippyAdArticleCard(
                                adArticle: article as AdArticle);
                          }

                          return GestureDetector(
                            onTap: () =>
                                controller.onHandleClickArticle(article),
                            child: ZippyArticleCard(
                              article: article,
                            ),
                          );
                        },
                      );
                    }),
              ));
        },
      ),
    );
  }
}
