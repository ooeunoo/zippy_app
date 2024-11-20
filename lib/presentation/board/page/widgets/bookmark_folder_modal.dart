import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/app/widgets/app_handle_bar.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/presentation/bookmark/page/widget/bookmark-action.dialog.dart';

class BookmarkFolderModal extends StatelessWidget {
  final Article article;
  final Function(String folderId) onFolderSelected;

  const BookmarkFolderModal({
    super.key,
    required this.article,
    required this.onFolderSelected,
  });
  @override
  Widget build(BuildContext context) {
    final bookmarkService = Get.find<BookmarkService>();

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(12)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius(16)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(AppDimens.width(10)),
              child: const AppHandleBar(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  '저장할 공간 선택',
                  style: Theme.of(context).textTheme.textLG.copyWith(
                        color: AppColor.graymodern100,
                        fontWeight: AppFontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColor.blue400),
                onPressed: () => showCreateFolderDialog(
                  context,
                  bookmarkService.onHandleCreateUserBookmarkFolder,
                ),
              ),
            ],
          ),
          AppSpacerV(value: AppDimens.height(12)),
          Expanded(
            child: Obx(() {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: bookmarkService.userBookmarkFolders.length,
                separatorBuilder: (_, __) => Divider(
                  color: AppColor.graymodern700,
                  height: AppDimens.height(1),
                ),
                itemBuilder: (context, index) {
                  final folder = bookmarkService.userBookmarkFolders[index];
                  return InkWell(
                    onTap: () {
                      onFolderSelected(folder.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimens.height(12),
                        horizontal: AppDimens.width(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppDimens.width(8)),
                            decoration: BoxDecoration(
                              color: AppColor.blue400.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radius(8)),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: AppColor.blue400,
                              size: AppDimens.width(24),
                            ),
                          ),
                          SizedBox(width: AppDimens.width(16)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  folder.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .textMD
                                      .copyWith(
                                        color: AppColor.graymodern200,
                                      ),
                                ),
                                if (folder.description != null) ...[
                                  SizedBox(height: AppDimens.height(4)),
                                  AppText(
                                    folder.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .textSM
                                        .copyWith(
                                          color: AppColor.graymodern500,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.delete_outline,
                              color: AppColor.rose400,
                              size: AppDimens.width(20),
                            ),
                            onPressed: () => showDeleteFolderConfirmationDialog(
                              context,
                              folder.id,
                              folder.name,
                              bookmarkService.onHandleDeleteUserBookmarkFolder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
