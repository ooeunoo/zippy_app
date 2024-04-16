import 'dart:async';
import 'package:cocomu/app/utils/assets.dart';
import 'package:cocomu/cocomu_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await GetStorage.init();
      // await dotenv.load(fileName: Assets.env);

      await initializeDateFormatting('ko_KR', null);

      return SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      ).then((_) => runApp(const CocomuApp()));
    },
    (error, stackTrace) async {
      print('error: $error - $stackTrace');
    },
  );
}
