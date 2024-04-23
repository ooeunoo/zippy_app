import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:zippy/presentation/pages/board/widgets/cocomu_card.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key,
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  @override
  Widget build(BuildContext context) {
    BoardController controller = Get.find();
    AdmobService admobService = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Obx(() => PageView.builder(
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              dragStartBehavior: DragStartBehavior.start,
              controller: controller.pageController,
              itemBuilder: (BuildContext context, int index) {
                return Obx(() {
                  Item item = controller.subscribers[index];
                  Channel? channel =
                      controller.getChannelByCategoryId(item.categoryId);
                  bool isBookmarked =
                      controller.bookmarkItemIds.contains(item.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppWebview(
                                    uri: item.url,
                                  )));
                    },
                    child: ZippyCard(
                        item: item,
                        channel: channel,
                        isBookMarked: isBookmarked,
                        toggleBookmark: controller.toggleBookmark),
                  );
                });
              },
              itemCount: controller.subscribers.length)),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: SizedBox(
          //     // 배너의 높이에 맞게 조정
          //     child: Obx(() {
          //       if (admobService.isBannerReady.value) {
          //         return AdWidget(ad: admobService.banner);
          //       } else {
          //         return Container(
          //             child: const Text("Error to load admob"));
          //       }
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
