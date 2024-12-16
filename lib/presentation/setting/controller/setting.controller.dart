// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
// import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
// import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';

// class SettingController extends GetxController {
//   // Observable for theme mode
//   final GetAppMetadata getAppMetadata = Get.find();
//   final UpdateAppMetadata updateAppMetadata = Get.find();

//   final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadThemeMode();
//   }

//   Future<void> _loadThemeMode() async {
//     final result = await getAppMetadata.execute();
//     result.fold(
//       (failure) => null,
//       (metadata) => currentThemeMode.value = metadata.themeMode,
//     );
//   }

//   void toggleTheme() {
//     final newThemeMode = currentThemeMode.value == ThemeMode.light
//         ? ThemeMode.dark
//         : ThemeMode.light;

//     currentThemeMode.value = newThemeMode;
//     updateAppMetadata.execute(UpdateAppMetadataParams(themeMode: newThemeMode));
//     Get.changeThemeMode(newThemeMode);
//   }
// }
