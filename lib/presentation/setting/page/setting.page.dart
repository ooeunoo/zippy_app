import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/setting/controller/setting.controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(12), vertical: AppDimens.height(10)),
        child: Column(
          children: [
            ListTile(
              title: AppText(
                '다크 모드',
                style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.gray100, fontWeight: AppFontWeight.medium),
              ),
              trailing: Obx(() {
                final currentMode = controller.currentThemeMode.value;
                final isDark = currentMode == ThemeMode.dark || 
                    (currentMode == ThemeMode.system && 
                     MediaQuery.platformBrightnessOf(context) == Brightness.dark);
                
                return GestureDetector(
                  onTap: () => controller.toggleTheme(),
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isDark ? AppColor.brand500 : AppColor.gray300,
                    ),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(
                            left: isDark ? 22 : 2,
                            top: 2,
                          ),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppHeaderWrap(
      child: AppHeader(
        backgroundColor: AppColor.transparent,
        automaticallyImplyLeading: true,
        title: AppText(
          "설정",
          style: Theme.of(context).textTheme.textMD.copyWith(
              color: AppColor.gray100, fontWeight: AppFontWeight.medium),
        ),
      ),
    );
  }
}
