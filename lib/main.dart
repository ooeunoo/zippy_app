import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/zippy_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
      }

      MobileAds.instance.initialize();
      await dotenv.load(fileName: Assets.env);
      await GetStorage.init();

      await initializeDateFormatting('ko_KR', null);

      return SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      ).then((_) => runApp(const ZippyApp()));
    },
    (error, stackTrace) async {
      print('error: $error - $stackTrace');
    },
  );
}
