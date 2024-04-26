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
import 'package:zippy/domain/model/ad_content.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:zippy/presentation/pages/board/widgets/zippy_ad_content_card.dart';
import 'package:zippy/presentation/pages/board/widgets/zippy_content_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key,
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoardController controller = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoadingItems.value) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.brand600,
                ),
              );
            } else if (controller.userChannels.isEmpty) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvg(Assets.logo, size: AppDimens.size(200)),
                    AppText("채널을 구독하시면 \n다양한 콘텐츠를 만나보실 수 있어요!",
                        align: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayXS
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
                          Get.toNamed(
                            Routes.channel,
                          );
                        },
                        width: double.infinity,
                        height: AppDimens.height(50),
                      ),
                    )),
                  ]);
            } else {
              return Obx(() => PageView.builder(
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  dragStartBehavior: DragStartBehavior.start,
                  controller: controller.pageController,
                  onPageChanged: (int pageIndex) =>
                      controller.onChangedItem(pageIndex),
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      Item item = controller.items[index];

                      if (item.isAd) {
                        AdContent content = item as AdContent;
                        // TODO: nativeAd null
                        return ZippyAdContentCard(content: content);
                      } else {
                        Content content = item as Content;

                        Channel? channel = controller
                            .getChannelByCategoryId(content.categoryId);
                        bool isBookmarked = controller.userBookmarkItemIds
                            .contains(content.id!);

                        return GestureDetector(
                          onTap: () => controller.onClickItem(content),
                          child: ZippyContentCard(
                              content: content,
                              channel: channel,
                              isBookMarked: isBookmarked,
                              toggleBookmark: controller.toggleBookmark),
                        );
                      }
                    });
                  },
                  itemCount: controller.items.length));
            }
          }),
        ],
      ),
    );
  }

  // Widget bannerAdWidget(AdmobService admobService) {
  //   return StatefulBuilder(
  //     builder: (context, setState) => Container(
  //       width: double.infinity,
  //       height: 100.0,
  //       alignment: Alignment.center,
  //       child: AdWidget(ad: admobService.nativeAd.value!),
  //     ),
  //   );
  // }
}
