import 'dart:math';

import 'package:cocomu/app/enum/community.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/data/providers/bobaedream/bobaedream_category.dart';
import 'package:cocomu/data/providers/dcinside/dcinside_category.dart';
import 'package:cocomu/data/providers/ppomppu/ppomppu_category.dart';
import 'package:cocomu/domain/entities/page_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum Pos { prev, cur, next }

enum ViewType { specific, random }

class BoardController extends GetxController {
  Rx<ViewType> viewType = Rx<ViewType>(ViewType.specific).obs();

  Rx<bool> isExceed = Rx<bool>(false).obs();
  RxList<String> prevUrls = RxList<String>([]).obs();
  RxMap<Pos, int> pos = RxMap({Pos.prev: 0, Pos.cur: 1, Pos.next: 2}).obs();
  List<WebViewController> webViewControllers = [
    WebViewController(),
    WebViewController(),
    WebViewController()
  ];
  List<int> progresses = [100, 100, 100];
  List<bool> loadings = [false, false, false];
  RxMap<Community, Map<dynamic, PageInfo>> pageInfo = RxMap({
    Community.dcinside: {
      DcinsideCategory.dcbest: const PageInfo(max: 223792, view: 223792)
    },
    Community.ppomppu: {
      PpomppuCategory.freeboard: const PageInfo(max: 8757903, view: 8757903),
    },
    Community.bobaedream: {
      BobaedreamCategory.best: const PageInfo(max: 733990, view: 733990),
    }
  }).obs();

  BoardController();

  @override
  onInit() {
    super.onInit();
    _createWebViewController(webViewControllers[0], 0);
    _createWebViewController(webViewControllers[1], 1);
    _createWebViewController(webViewControllers[2], 2);

    _loadWebView(webViewControllers[0]);
    _loadWebView(webViewControllers[1]);
    _loadWebView(webViewControllers[2]);
  }

  WebViewController _createWebViewController(
      WebViewController controller, int index) {
    return controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(onPageStarted: (String url) {
          loadings[index] = true;
        }, onPageFinished: (String url) {
          loadings[index] = false;
        }, onProgress: (int progress) {
          progresses[index] = progress;
        }),
      );
  }

  moveToNext() async {
    int cur = pos[Pos.cur]!;
    int prev = pos[Pos.prev]!;
    int next = pos[Pos.next]!;

    String? prevUrl = await webViewControllers[pos[Pos.prev]!].currentUrl();
    prevUrls.add(prevUrl!);

    pos[Pos.cur] = next;
    pos[Pos.prev] = cur;
    pos[Pos.next] = prev;

    _loadWebView(webViewControllers[pos[Pos.next]!]);
  }

  moveToPrev() {
    String? prevUrl = prevUrls.isNotEmpty ? prevUrls.last : null;
    if (prevUrl != null) {
      int cur = pos[Pos.cur]!;
      int prev = pos[Pos.prev]!;
      int next = pos[Pos.next]!;

      // controller로 위치 수정
      pos[Pos.cur] = prev;
      pos[Pos.next] = cur;
      pos[Pos.prev] = next;
      prevUrls.removeLast();
      _loadWebView(webViewControllers[pos[Pos.prev]!], prevUrl: prevUrl);
    }
  }

  _loadWebView(WebViewController controller, {String? prevUrl}) {
    if (prevUrl != null) {
      return controller.loadRequest(Uri.parse(prevUrl));
    } else {
      List<Community> communities = Community.values;
      Random random = Random();
      Community randomCommunity =
          communities[random.nextInt(communities.length)];

      String nextUrl = '';

      switch (randomCommunity) {
        case Community.dcinside:
          PageInfo info =
              pageInfo[Community.dcinside]![DcinsideCategory.dcbest]!;
          int curView = info.view - 1;
          pageInfo[Community.dcinside]![DcinsideCategory.dcbest] =
              pageInfo[Community.dcinside]![DcinsideCategory.dcbest]!
                  .copyWith(view: curView);

          nextUrl = 'https://gall.dcinside.com/dcbest/$curView';
          break;
        case Community.ppomppu:
          PageInfo info =
              pageInfo[Community.ppomppu]![PpomppuCategory.freeboard]!;
          int curView = info.view - 1;
          pageInfo[Community.ppomppu]![PpomppuCategory.freeboard] =
              pageInfo[Community.ppomppu]![PpomppuCategory.freeboard]!
                  .copyWith(view: curView);

          nextUrl =
              'https://www.ppomppu.co.kr/zboard/view.php?id=freeboard&no=$curView';
          break;

        case Community.bobaedream:
          PageInfo info =
              pageInfo[Community.bobaedream]![BobaedreamCategory.best]!;
          int curView = info.view - 1;
          pageInfo[Community.bobaedream]![BobaedreamCategory.best] =
              pageInfo[Community.bobaedream]![BobaedreamCategory.best]!
                  .copyWith(view: curView);

          nextUrl = 'https://www.bobaedream.co.kr/view?code=best&No=$curView';
          break;
      }

      return controller..loadRequest(Uri.parse(nextUrl));
    }
  }

  @override
  refresh() {
    print('refresh');
  }
}
