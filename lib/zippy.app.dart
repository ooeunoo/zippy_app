import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/zippy.dependency.dart';
import 'package:zippy/app/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zippy/zippy_version.dart';

class ZippyApp extends StatefulWidget {
  const ZippyApp({super.key});

  @override
  State<ZippyApp> createState() => _ZippyAppState();
}

class _ZippyAppState extends State<ZippyApp> {
  @override
  void initState() {
    super.initState();
    initPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('notification:$notification');
      print('android:$android');

      if (notification != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //   notification.hashCode,
        //   notification.title,
        //   notification.body,
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       channel.id,
        //       channel.name,
        //       channelDescription: channel.description,
        //       icon: '@mipmap/ic_launcher',
        //     ),
        //     iOS: DarwinNotificationDetails(),
        //   ),
        // );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      print('message:${message.data}');
      // 알림 클릭 시 특정 화면으로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(AppDimens.screenW, AppDimens.screenH),
        builder: (context, __) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Zippy",
            defaultTransition: Transition.fade,
            initialBinding: ZippyBindings(),
            getPages: AppPages.routes,
            initialRoute: AppPages.initial,
            theme: AppTheme.darkTheme(context),
            darkTheme: AppTheme.darkTheme(context),
            // themeMode: ThemeMode.system,
            translations: ZippyTranslations(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('ko', 'KR'),
            builder: (context, child) =>
                ZippyVersion(child: child ?? const SizedBox()),
          );
        });
  }

  Future<void> initPlugin() async {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
