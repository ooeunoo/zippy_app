import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:zippy/app/utils/assets.dart';

class FingerGestureOverlayGuide extends StatelessWidget {
  const FingerGestureOverlayGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(Assets.gestureSwipeUp),
    );
  }
}
