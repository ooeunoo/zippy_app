import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_text_input.dart';
import 'package:zippy/presentation/keyword_notification/controller/keyword_notification.controller.dart';

class KeywordNotificationView extends StatefulWidget {
  const KeywordNotificationView({super.key});

  @override
  State<KeywordNotificationView> createState() =>
      _KeywordNotificationViewState();
}

class _KeywordNotificationViewState extends State<KeywordNotificationView> {
  final KeywordNotificationController controller = Get.find();
  final TextEditingController _keywordController = TextEditingController();
  final FocusNode _keywordFocusNode = FocusNode();

  @override
  void dispose() {
    _keywordController.dispose();
    _keywordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20),
            vertical: AppDimens.height(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDescription(),
              AppSpacerV(value: AppDimens.height(16)),
              _buildKeywordNewItemInputField(),
              AppSpacerV(value: AppDimens.height(20)),
              AppDivider(),
              AppSpacerV(value: AppDimens.height(10)),
              _buildKeywordList(),
              AppSpacerV(value: AppDimens.height(16)),
            ],
          ),
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
          "뉴스 알람 설정",
          style: Theme.of(context).textTheme.textMD.copyWith(
                color: AppThemeColors.textHigh(context),
                fontWeight: AppFontWeight.medium,
              ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return AppText(
      "키워드가 포함된 뉴스가 있다면\n가장 먼저 알림을 보내드릴게요 🤗",
      style: Theme.of(context).textTheme.textXS.copyWith(
            color: AppThemeColors.textLowest(context),
          ),
    );
  }

  Widget _buildKeywordNewItemInputField() {
    final TextEditingController keywordController = TextEditingController();

    return Container(
      child: Stack(
        children: [
          AppTextInput(
            controller: keywordController,
            hintText: '새 키워드 추가',
            hintTextStyle: Theme.of(context).textTheme.textXS.copyWith(
                  color: AppThemeColors.textLow(context),
                ),
            autofocus: false,
            onTapOutside: (_) => Get.focusScope?.unfocus(),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                if (keywordController.text.isEmpty) {
                  return;
                }
                controller.onHandleCreateNotification(keywordController.text);
                keywordController.clear();
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.width(12),
                      vertical: AppDimens.height(8)),
                  child: AppText("추가",
                      style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppColor.brand600,
                            fontWeight: AppFontWeight.bold,
                          )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordList() {
    return Obx(() => Column(
          children: controller.userKeywordNotifications
              .map(
                (notification) => _buildKeywordItem(
                  notification.keyword,
                  notification.isActive,
                  onDelete: () =>
                      controller.onHandleDeleteNotification(notification),
                ),
              )
              .toList(),
        ));
  }

  Widget _buildKeywordItem(String title, bool isEnabled,
      {required VoidCallback onDelete}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
          vertical: AppDimens.height(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                title,
                style: Theme.of(context).textTheme.textXS.copyWith(
                      color: AppThemeColors.textHigh(context),
                    ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                color: AppThemeColors.textMedium(context),
                size: AppDimens.size(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
