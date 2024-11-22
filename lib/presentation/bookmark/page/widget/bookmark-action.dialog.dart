import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

void showCreateFolderDialog(BuildContext context,
    Function(UserBookmarkFolder) onHandleCreateUserBookmarkFolder) {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColor.graymodern900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimens.width(8)),
              decoration: BoxDecoration(
                color: AppColor.brand500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radius(8)),
              ),
              child: Icon(
                Icons.create_new_folder,
                color: AppColor.brand400,
                size: AppDimens.size(20),
              ),
            ),
            AppSpacerH(value: AppDimens.width(12)),
            AppText(
              '새 폴더 만들기',
              style: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppColor.graymodern100,
                    fontWeight: AppFontWeight.bold,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern200,
                  ),
              decoration: InputDecoration(
                hintText: '폴더 이름',
                hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern600,
                    ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.graymodern700),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.brand400),
                ),
              ),
            ),
            AppSpacerV(value: AppDimens.height(20)),
            TextField(
              controller: descriptionController,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern200,
                  ),
              decoration: InputDecoration(
                hintText: '폴더 설명 (선택)',
                hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern600,
                    ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.graymodern700),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.brand400),
                ),
              ),
            ),
            AppSpacerV(value: AppDimens.height(8)),
            AppText(
              '북마크를 구분하는데 도움이 되는 설명을 추가해보세요',
              style: Theme.of(context).textTheme.textXS.copyWith(
                    color: AppColor.graymodern500,
                    height: 1.4,
                  ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
          vertical: AppDimens.height(16),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: AppText(
                  '취소',
                  style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppColor.graymodern400,
                      ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    onHandleCreateUserBookmarkFolder(
                      UserBookmarkFolder(
                        id: const Uuid().v4(),
                        name: nameController.text,
                        description: descriptionController.text.isNotEmpty
                            ? descriptionController.text
                            : null,
                        createdAt: DateTime.now(),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColor.brand500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radius(8)),
                  ),
                ),
                child: AppText(
                  '생성',
                  style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppColor.white,
                        fontWeight: AppFontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showDeleteFolderConfirmationDialog(BuildContext context, String folderId,
    String folderName, Function(String) onHandleDeleteUserBookmarkFolder) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColor.graymodern900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColor.rose500,
              size: AppDimens.size(24),
            ),
            AppSpacerH(value: AppDimens.width(12)),
            AppText(
              '폴더 삭제',
              style: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppColor.graymodern100,
                    fontWeight: AppFontWeight.bold,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '정말로 "$folderName" 폴더를 삭제하시겠습니까?',
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern200,
                  ),
            ),
            AppSpacerV(value: AppDimens.height(8)),
            AppText(
              '폴더 내의 모든 북마크가 함께 삭제됩니다.',
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.rose500,
                  ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.all(AppDimens.width(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              '취소',
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern400,
                  ),
            ),
          ),
          FilledButton(
            onPressed: () {
              onHandleDeleteUserBookmarkFolder(folderId);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.rose500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius(8)),
              ),
            ),
            child: AppText(
              '삭제',
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.white,
                    fontWeight: AppFontWeight.bold,
                  ),
            ),
          ),
        ],
      );
    },
  );
}

void showFolderOptionsDialog(BuildContext context, String folderId,
    String folderName, Function(String) onHandleDeleteUserBookmarkFolder) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColor.graymodern900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius(12)),
        ),
        title: AppText(
          folderName,
          style: Theme.of(context).textTheme.textLG.copyWith(
                color: AppColor.graymodern100,
                fontWeight: AppFontWeight.bold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                showDeleteFolderConfirmationDialog(
                  context,
                  folderId,
                  folderName,
                  onHandleDeleteUserBookmarkFolder,
                );
              },
              leading: Icon(
                Icons.delete_outline,
                color: AppColor.rose500,
                size: AppDimens.size(20),
              ),
              title: AppText(
                '폴더 삭제',
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.rose500,
                    ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
