import 'dart:async';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:cocomu/presentation/controllers/board/board_controller.dart';
import 'package:cocomu/presentation/pages/board/transformer/transformer.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_card.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Board extends GetView<BoardController> {
  const Board({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('페이지 뷰'),
        ),
        body: controller.subscribers.isEmpty
            ? const Center(
                child: Text(""),
              )
            : TransformerPageView(
                scrollDirection: Axis.vertical,
                curve: Curves.easeInBack,
                transformer: DeepthPageTransformer(),
                pageSnapping: true,
                pageController: controller.pageController,
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
                        community: community
                      ),
                    );
                  });
                },
                itemCount: controller.subscribers.length));
  }
}
