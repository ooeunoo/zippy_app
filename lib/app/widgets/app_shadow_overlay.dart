import 'package:flutter/material.dart';

class AppShadowOverlay extends StatelessWidget {
  final Widget child;

  final Color shadowColor;

  const AppShadowOverlay(
      {super.key, required this.child, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp,
                colors: [
                  Colors.transparent,
                  shadowColor.withOpacity(0.5),
                  shadowColor.withOpacity(1),
                ],
                stops: const [
                  0.0,
                  0.5,
                  1.0,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
