import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> toShare(
  String title,
  String subject,
) async {
  await Share.share(title,
      subject: subject,
      sharePositionOrigin:
          Rect.fromPoints(const Offset(2, 2), const Offset(3, 3)));
}
