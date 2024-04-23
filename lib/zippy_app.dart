import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/zippy_dependency.dart';
import 'package:zippy/zippy_translation.dart';
import 'package:zippy/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ZippyApp extends StatelessWidget {
  const ZippyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

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
            darkTheme: themeDark(context),
            themeMode: getThemeMode(themeController.theme),
            translations: ZippyTranslations(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('ko', 'KR'),
          );
        });
  }

  ThemeMode getThemeMode(String type) {
    ThemeMode themeMode = ThemeMode.system;
    switch (type) {
      case "system":
        themeMode = ThemeMode.system;
        break;
      case "dark":
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.light;
        break;
    }

    return themeMode;
  }
}
