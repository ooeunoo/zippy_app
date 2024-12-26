import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // 알림 설정
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
