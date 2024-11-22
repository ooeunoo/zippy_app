import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zippy/app/utils/constants.dart';

class ShareConfig {
  static const String appName = 'Zippy';
  static const String appTagline = '트렌드를 한눈에, 지피';
  static const String appStoreUrl = Constants.appstoreUrl;
  static const String playStoreUrl = Constants.playstoreUrl;

  // 앱 다운로드 링크 가져오기
  static String get storeLink => Platform.isIOS ? appStoreUrl : playStoreUrl;
  static String get storeName => Platform.isIOS ? 'App Store' : 'Play Store';

  static const List<String> slogans = [
    "새로운 시각을 발견하다 ✨",
    "트렌드의 중심에서 🎯",
    "똑똑한 당신의 선택 🧠",
    "세상을 더 넓게 보다 🌏",
    "지금 이 순간의 트렌드 🚀",
    "당신의 스마트한 뉴스 친구 📱",
  ];

  static const List<List<String>> hashtagSets = [
    ['#NewsPick', '#TrendAlert', '#MustRead'],
    ['#TodaysPick', '#HotTopic', '#ZippyTime'],
    ['#TrendingNow', '#NewsFlow', '#StayZippy'],
    ['#ZippyNews', '#SmartReader', '#TrendWatch'],
  ];
}

enum ShareFormat { quote }

Future<void> toShare(
  String title,
  String link, {
  bool includeAppInfo = true,
}) async {
  final shareFormat = _getRandomShareFormat();
  final slogan = _getRandomFromList(ShareConfig.slogans);
  final hashtags = _getRandomFromList(ShareConfig.hashtagSets);

  final StringBuffer shareText = StringBuffer();

  switch (shareFormat) {
    // case ShareFormat.minimal:
    //   _buildMinimalFormat(shareText, title, link, slogan, hashtags);
    //   break;
    // case ShareFormat.magazine:
    //   _buildMagazineFormat(shareText, title, link, slogan, hashtags);
    //   break;
    case ShareFormat.quote:
      _buildQuoteFormat(shareText, title, link, slogan, hashtags);
      break;
    // case ShareFormat.modern:
    //   _buildModernFormat(shareText, title, link, slogan, hashtags);
    //   break;
    // case ShareFormat.elegant:
    //   _buildElegantFormat(shareText, title, link, slogan, hashtags);
    //   break;
  }

  await Share.share(
    shareText.toString(),
    sharePositionOrigin: Rect.fromPoints(
      const Offset(2, 2),
      const Offset(3, 3),
    ),
  );
}

T _getRandomFromList<T>(List<T> list) {
  return list[DateTime.now().microsecond % list.length];
}

ShareFormat _getRandomShareFormat() {
  return ShareFormat
      .values[DateTime.now().microsecond % ShareFormat.values.length];
}

void _buildMinimalFormat(
  StringBuffer buffer,
  String title,
  String link,
  String slogan,
  List<String> hashtags,
) {
  buffer.writeln('${title.trim()} 👀');
  buffer.writeln('');
  buffer.writeln('$link');
  buffer.writeln('');
  buffer.writeln('via ${ShareConfig.appName} ⚡️ $slogan');
  buffer.writeln('');
  buffer.writeln('${ShareConfig.appName} 다운로드');
  buffer.writeln('${ShareConfig.storeName}: ${ShareConfig.storeLink}');
  buffer.writeln('');
  buffer.writeln(hashtags.join(' '));
}

void _buildMagazineFormat(
  StringBuffer buffer,
  String title,
  String link,
  String slogan,
  List<String> hashtags,
) {
  buffer.writeln('┏━━━━ TRENDING NOW ━━━━┓');
  buffer.writeln('');
  buffer.writeln('📌 ${title.trim()}');
  buffer.writeln('');
  buffer.writeln('더 읽기 👉 $link');
  buffer.writeln('');
  buffer.writeln('╭──◆ ${ShareConfig.appName} ◆──╮');
  buffer.writeln('   $slogan');
  buffer.writeln('╰─────────────────╯');
  buffer.writeln('');
  buffer.writeln('📲 ${ShareConfig.appName} 앱 다운로드');
  buffer.writeln('${ShareConfig.storeName}: ${ShareConfig.storeLink}');
  buffer.writeln('');
  buffer.writeln(hashtags.join(' '));
}

void _buildQuoteFormat(
  StringBuffer buffer,
  String title,
  String link,
  String slogan,
  List<String> hashtags,
) {
  buffer.writeln('❝ ${title.trim()} ❞');
  buffer.writeln('');
  buffer.writeln('🔍 자세히 보기: $link');
  buffer.writeln('');
  buffer.writeln('⚡️ ${ShareConfig.appName}');
  buffer.writeln('   $slogan');
  buffer.writeln('');
  buffer.writeln('📱 앱 다운로드하기');
  buffer.writeln('${ShareConfig.storeName}: ${ShareConfig.storeLink}');
  buffer.writeln('');
  buffer.writeln(hashtags.join(' '));
}

void _buildModernFormat(
  StringBuffer buffer,
  String title,
  String link,
  String slogan,
  List<String> hashtags,
) {
  buffer.writeln('━━━━━━━━━━━━━━━');
  buffer.writeln('🎯 트렌딩 뉴스');
  buffer.writeln('━━━━━━━━━━━━━━━');
  buffer.writeln('');
  buffer.writeln(title.trim());
  buffer.writeln('');
  buffer.writeln('📱 바로가기');
  buffer.writeln('$link');
  buffer.writeln('');
  buffer.writeln('✨ ${ShareConfig.appName}');
  buffer.writeln('$slogan');
  buffer.writeln('');
  buffer.writeln('📲 앱 다운로드');
  buffer.writeln('${ShareConfig.storeName}: ${ShareConfig.storeLink}');
  buffer.writeln('');
  buffer.writeln(hashtags.join(' '));
}

void _buildElegantFormat(
  StringBuffer buffer,
  String title,
  String link,
  String slogan,
  List<String> hashtags,
) {
  buffer.writeln('• • • • • • • • • •');
  buffer.writeln('');
  buffer.writeln('${title.trim()} 📰');
  buffer.writeln('');
  buffer.writeln('더 알아보기 ⤵️');
  buffer.writeln('$link');
  buffer.writeln('');
  buffer.writeln('${ShareConfig.appName} | $slogan');
  buffer.writeln('');
  buffer.writeln('앱 다운로드 💫');
  buffer.writeln('${ShareConfig.storeName}: ${ShareConfig.storeLink}');
  buffer.writeln('');
  buffer.writeln(hashtags.join(' '));
  buffer.writeln('');
  buffer.writeln('• • • • • • • • • •');
}
