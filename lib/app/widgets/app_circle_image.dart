import 'package:flutter/material.dart';

class AppCircleImage extends StatelessWidget {
  final double size;
  final String image;

  const AppCircleImage(this.image, {super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
