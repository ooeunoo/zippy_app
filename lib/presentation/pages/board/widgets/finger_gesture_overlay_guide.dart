import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zippy/app/utils/assets.dart';

class FingerGestureOverlayGuide extends StatelessWidget {
  final VoidCallback? onSkipPressed;

  const FingerGestureOverlayGuide({super.key, required this.onSkipPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (_) {
        onSkipPressed?.call();
      },
      behavior: HitTestBehavior.opaque,
      onTap: onSkipPressed,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 50,
            right: 0,
            child: Container(
              color: Colors.transparent,
              width: 30,
              height: 30,
              child: Lottie.asset(
                width: 30,
                height: 30,
                fit: BoxFit.scaleDown,
                Assets.gestureSwipeUp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
