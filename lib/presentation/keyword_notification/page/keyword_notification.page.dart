import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKeywordNewItemInputField(),
            AppSpacerV(value: AppDimens.height(20)),
            _buildKeywordList(),
            AppSpacerV(value: AppDimens.height(16)),
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
          "키워드 알림 설정",
          style: Theme.of(context).textTheme.textMD.copyWith(
                color: AppThemeColors.textHigh(context),
                fontWeight: AppFontWeight.medium,
              ),
        ),
      ),
    );
  }

  Widget _buildKeywordNewItemInputField() {
    final TextEditingController keywordController = TextEditingController();
    final RxBool isValid = false.obs;

    keywordController.addListener(() {
      final text = keywordController.text;
      isValid.value = text.isNotEmpty && text.length >= 2;
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(12)),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: AppTextInput(
              controller: keywordController,
              hintText: '새 키워드 추가',
              hintTextStyle: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppThemeColors.textHigh(context),
                  ),
              autofocus: false,
              onTapOutside: (_) => Get.focusScope?.unfocus(),
            ),
          ),
          AppSpacerH(value: AppDimens.width(16)),
          Expanded(
            flex: 1,
            child: Obx(() => Container(
                  decoration: BoxDecoration(
                    color: isValid.value
                        ? AppThemeColors.buttonBackgroundColor(context)
                        : AppThemeColors.buttonDisableBackgroundColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add,
                        color: isValid.value
                            ? AppThemeColors.textHighest(context)
                            : AppThemeColors.textLow(context)),
                    onPressed: () {
                      controller
                          .onHandleCreateNotification(keywordController.text);
                      keywordController.clear();
                    },
                  ),
                )),
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
                  notification.isActive ? '알림: 활성화' : '알림: 비활성화',
                  notification.isActive,
                  onToggle: (value) => controller
                      .onHandleToggleOrCreateNotification(notification.keyword),
                  onDelete: () =>
                      controller.onHandleDeleteNotification(notification),
                ),
              )
              .toList(),
        ));
  }

  Widget _buildKeywordItem(String title, String subtitle, bool isEnabled,
      {required Function(bool) onToggle, required VoidCallback onDelete}) {
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.startToEnd,
      dismissThresholds: const {DismissDirection.startToEnd: 0.8},
      confirmDismiss: (DismissDirection direction) async {
        return showKeywordDeleteDialog(title, onDelete);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () => onToggle(!isEnabled),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppDimens.width(12),
            vertical: AppDimens.height(6),
          ),
          decoration: BoxDecoration(
            color: AppThemeColors.bottomSheetBackground(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.size(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: Theme.of(context).textTheme.textLG.copyWith(
                              color: AppThemeColors.textHigh(context),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                  activeColor: AppThemeColors.switchActiveColor(context),
                  activeTrackColor:
                      AppThemeColors.switchActiveTrackColor(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
