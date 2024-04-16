import 'package:cocomu/app/utils/styles/dimens.dart';
import 'package:cocomu/app/widgets/app.snak_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CocomuWebview extends StatelessWidget {
  final WebViewController controller;
  final bool loading;
  final Function(bool state) refreshScrollState;

  const CocomuWebview({
    super.key,
    required this.controller,
    required this.loading,
    required this.refreshScrollState,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CupertinoActivityIndicator())
        : Stack(children: [
            WebViewWidget(
                controller: controller,
                gestureRecognizers: {}
                  ..add(Factory<AllowVerticalDragGestureRecognizer>(() {
                    return AllowVerticalDragGestureRecognizer()
                      ..onStart = (DragStartDetails details) {
                        // refreshScrollState(true);
                      }
                      ..onUpdate = (DragUpdateDetails detials) {
                        // refreshScrollState(true);
                      }
                      ..onEnd = (DragEndDetails details) {
                        // refreshScrollState(false);
                      };
                  }))),
            // Action
          ]);
  }
}

class AllowVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer); //override rejectGesture here
  }
}
