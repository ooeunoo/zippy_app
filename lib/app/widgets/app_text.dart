import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle style;
  final TextAlign align;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
    this.text, {
    super.key,
    required this.style,
    this.color,
    this.align = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: style,
      overflow: maxLines != null ? overflow : null,
      maxLines: maxLines,
    );
  }
}
