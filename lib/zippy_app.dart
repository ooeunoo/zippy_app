import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/zippy_dependency.dart';
import 'package:zippy/zippy_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ZippyApp extends StatefulWidget {
  const ZippyApp({super.key});

  @override
  State<ZippyApp> createState() => _ZippyAppState();
}

class _ZippyAppState extends State<ZippyApp> {
  @override
  void initState() {
    initPlugin();
    super.initState();
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
            theme: themeLight(context),
            translations: ZippyTranslations(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('ko', 'KR'),
          );
        });
  }

  // App Tracking Transparency
  Future<void> initPlugin() async {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
