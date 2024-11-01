import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_button.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/ad_content.model.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_ad_content_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              // DrawerHeader(
              //   decoration: const BoxDecoration(
              //     color: AppColor.graymodern900,
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       AppText(
              //         "최신 콘텐츠",
              //         style: Theme.of(context).textTheme.text2XL.copyWith(
              //               color: AppColor.graymodern100,
              //             ),
              //       ),
              //     ],
              //   ),
              // ),
              // 아티클 리스트
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      Article article = controller.articles[index];
                      if (!article.isAd) {
                        Platform? platform =
                            controller.getPlatformBySourceId(article.sourceId);
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
                                platform?.name ?? "",
                                style:
                                    Theme.of(context).textTheme.textXS.copyWith(
                                          color: AppColor.graymodern400,
                                        ),
                              ),
                              onTap: () {
                                controller.jumpToArticle(index);
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
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoadingContents.value ||
                controller.isLoadingUserSubscription.value) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.brand600,
                ),
              );
            } else if (controller.userSubscriptions.isEmpty) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvg(Assets.logo, size: AppDimens.size(200)),
                    AppText("채널을 구독하시면 \n다양한 콘텐츠를 만나보실 수 있어요!",
                        align: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .text2XL
                            .copyWith(color: AppColor.graymodern100)),
                    AppSpacerV(value: AppDimens.height(60)),
                    Center(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
                      child: AppButton(
                        '채널 구독하기',
                        color: AppColor.brand600,
                        titleStyle: Theme.of(context)
                            .textTheme
                            .textLG
                            .copyWith(color: AppColor.graymodern100),
                        onPressed: () {
                          Get.toNamed(Routes.subscription);
                        },
                        width: double.infinity,
                        height: AppDimens.height(50),
                      ),
                    )),
                  ]);
            } else {
              return RefreshIndicator(
                color: AppColor.brand600,
                backgroundColor: AppColor.graymodern950,
                displacement: 50,
                strokeWidth: 3,
                onRefresh: () async {
                  await controller.refreshItem();
                },
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  dragStartBehavior: DragStartBehavior.start,
                  controller: controller.pageController,
                  onPageChanged: (int pageIndex) =>
                      controller.jumpToArticle(pageIndex),
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      Article article = controller.articles[index];
                      if (article.isAd) {
                        AdContent adContent = article as AdContent;
                        return ZippyAdContentCard(content: adContent);
                      } else {
                        Platform? platform =
                            controller.getPlatformBySourceId(article.sourceId);
                        bool isBookmarked =
                            controller.isBookmarked(article.id!);
                        return GestureDetector(
                          onTap: () => controller.onClickArticle(article),
                          child: ZippyArticleCard(
                            article: article,
                            platform: platform,
                            isBookMarked: isBookmarked,
                            toggleBookmark: controller.toggleBookmark,
                            openMenu: controller.onOpenMenu,
                          ),
                        );
                      }
                    });
                  },
                  itemCount: controller.articles.length,
                ),
              );
            }
          }),
          // if (admobService.bannerAd.value != null) ...{
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       color: AppColor.graymodern950,
          //       width: admobService.bannerAd.value?.size.width.toDouble(),
          //       height: admobService.bannerAd.value?.size.height.toDouble(),
          //       child: AdWidget(ad: admobService.bannerAd.value!),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }
}
