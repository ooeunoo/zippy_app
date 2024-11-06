import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';

enum ArticleViewType { Keypoint, Summary, Original }

extension ArticleViewTypeExt on ArticleViewType {
  (IconData icon, String label, Color color) get buttonConfig {
    switch (this) {
      case ArticleViewType.Keypoint:
        return (Icons.format_list_bulleted_rounded, '키포인트', AppColor.brand600);
      case ArticleViewType.Summary:
        return (Icons.summarize_rounded, '요약보기', AppColor.brand600);
      case ArticleViewType.Original:
        return (Icons.article_rounded, '원문보기', AppColor.gray700);
    }
  }
}
