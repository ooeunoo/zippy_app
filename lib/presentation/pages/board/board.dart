import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/domain/model/community.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:zippy/presentation/pages/board/widgets/cocomu_card.dart';
import 'package:zippy/presentation/pages/board/widgets/cocomu_webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Board extends StatefulWidget {
  const Board({
    super.key,
  });

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
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
                  Community? community =
                      controller.getCommunityByCategoryId(item.categoryId);
                  bool isBookmarked =
                      controller.bookmarkItemIds.contains(item.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ZippyWebview(
                                    uri: item.url,
                                  )));
                    },
                    child: ZippyCard(
                        item: item,
                        community: community,
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
