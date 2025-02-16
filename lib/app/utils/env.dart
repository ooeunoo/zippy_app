// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String production = 'production';
String development = 'development';

abstract class ENV {
  ENV._();

  static String ZIPPY_ENV = kReleaseMode ? production : development;

  static String SUPABASE_URL = kReleaseMode
      ? dotenv.env['SUPABASE_URL'] as String
      : dotenv.env['SUPABASE_URL_DEV'] as String;

  static String SUPABASE_ANON_KEY = kReleaseMode
      ? dotenv.env['SUPABASE_ANON_KEY'] as String
      : dotenv.env['SUPABASE_ANON_KEY_DEV'] as String;

  static String GOOGLE_ADMOB_CARD_NATIVE_IOS = kReleaseMode
      ? dotenv.env['GOOGLE_ADMOB_CARD_NATIVE_IOS'] as String
      : dotenv.env['GOOGLE_ADMOB_CARD_NATIVE_IOS_DEV'] as String;

  static String GOOGLE_ADMOB_CARD_NATIVE_AOS = kReleaseMode
      ? dotenv.env['GOOGLE_ADMOB_CARD_NATIVE_AOS'] as String
      : dotenv.env['GOOGLE_ADMOB_CARD_NATIVE_AOS_DEV'] as String;

  static String GOOGLE_ADMOB_BOTTOM_BANNER_IOS = kReleaseMode
      ? dotenv.env['GOOGLE_ADMOB_BOTTOM_BANNER_IOS'] as String
      : dotenv.env['GOOGLE_ADMOB_BOTTOM_BANNER_IOS_DEV'] as String;

  static String GOOGLE_ADMOB_BOTTOM_BANNER_AOS = kReleaseMode
      ? dotenv.env['GOOGLE_ADMOB_BOTTOM_BANNER_AOS'] as String
      : dotenv.env['GOOGLE_ADMOB_BOTTOM_BANNER_AOS_DEV'] as String;

  static String KAKAO_NATIVE_APP_KEY = kReleaseMode
      ? dotenv.env['KAKAO_NATIVE_APP_KEY'] as String
      : dotenv.env['KAKAO_NATIVE_APP_KEY_DEV'] as String;

  static String KAKAO_JAVASCRIPT_KEY = kReleaseMode
      ? dotenv.env['KAKAO_JAVASCRIPT_KEY'] as String
      : dotenv.env['KAKAO_JAVASCRIPT_KEY_DEV'] as String;

  static String GOOGLE_WEB_CLIENT_ID = kReleaseMode
      ? dotenv.env['GOOGLE_WEB_CLIENT_ID'] as String
      : dotenv.env['GOOGLE_WEB_CLIENT_ID_DEV'] as String;

  static String GOOGLE_IOS_CLIENT_ID = kReleaseMode
      ? dotenv.env['GOOGLE_IOS_CLIENT_ID'] as String
      : dotenv.env['GOOGLE_IOS_CLIENT_ID_DEV'] as String;
}
