import 'package:cocomu/app/services/admob_service.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:cocomu/presentation/controllers/board/board_controller.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_card.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Board extends GetView<BoardController> {
  const Board({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdmobService admobService = Get.find();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  dragStartBehavior: DragStartBehavior.start,
                  controller: controller.pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      Item item = controller.subscribers[index];
                      Community community =
                          controller.getCommunityByCategoryId(item.categoryId);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CocomuWebview(
                                        uri: item.url,
                                      )));
                        },
                        child: CocomuCard(
                          item: item,
                          community: community,
                          isBookMarked: true,
                        ),
                      );
                    });
                  },
                  itemCount: controller.subscribers.length),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  // 배너의 높이에 맞게 조정
                  child: Obx(() {
                    if (admobService.isBannerReady.value) {
                      return AdWidget(ad: admobService.banner);
                    } else {
                      return Container(
                          child: const Text("Error to load admob"));
                    }
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
