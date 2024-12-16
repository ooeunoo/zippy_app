import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/appmetadata.service.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/data/providers/hive.provider.dart';
import 'package:zippy/data/sources/app_metadata.source.dart';
import 'package:zippy/domain/repositories/app_metadata.repository.dart';
import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';
import 'package:zippy/zippy.app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      //   // await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
      // }

      await initHive();
      await initAppMetadata();
      await MobileAds.instance.initialize();
      await dotenv.load(fileName: kReleaseMode ? Assets.env : Assets.envDev);
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

Future<void> initHive() async {
  HiveProvider hiveProvider = HiveProvider();
  await hiveProvider.init();
  await hiveProvider.openBox();
  Get.put<HiveProvider>(hiveProvider, permanent: true);
}

Future<void> initAppMetadata() async {
  Get.put<AppMetadataDataSource>(
      AppMetadataDataSourceImpl(hiveProvider: Get.find()));
  Get.put<AppMetadataRepository>(AppMetadataRepositoryImpl(Get.find()));
  Get.put<UpdateAppMetadata>(UpdateAppMetadata(Get.find()));
  Get.put<GetAppMetadata>(GetAppMetadata(Get.find()));
  Get.put<AppMetadataService>(AppMetadataService());
}
