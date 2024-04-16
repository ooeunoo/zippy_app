import 'package:cocomu/app/routes/app_pages.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';
import 'package:cocomu/app/utils/styles/theme.dart';
import 'package:cocomu/cocomu_dependency.dart';
import 'package:cocomu/cocomu_translation.dart';
import 'package:cocomu/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CocomuApp extends StatelessWidget {
  const CocomuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return ScreenUtilInit(
        designSize: Size(AppDimens.screenW, AppDimens.screenH),
        builder: (context, __) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Cocomu",
            defaultTransition: Transition.fade,
            getPages: AppPages.routes,
            initialRoute: AppPages.initial,
            initialBinding: CocomuBindings(),
            theme: themeLight(context),
            darkTheme: themeDark(context),
            themeMode: getThemeMode(themeController.theme),
            translations: CocomuTranslations(),
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
