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
  final Function(int folderId) onFolderSelected;

  const BookmarkFolderModal({
    super.key,
    required this.article,
    required this.onFolderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkService = Get.find<BookmarkService>();

    return Container(
      padding: EdgeInsets.only(
        top: AppDimens.height(8),
        bottom: AppDimens.height(24),
      ),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius(28)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSpacerV(value: AppDimens.height(8)),
          const AppHandleBar(color: AppColor.graymodern700),
          AppSpacerV(value: AppDimens.height(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    '저장할 공간 선택',
                    style: Theme.of(context).textTheme.textLG.copyWith(
                          color: AppColor.graymodern100,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimens.radius(12)),
                    onTap: () => showCreateFolderDialog(
                      context,
                      bookmarkService.onHandleCreateUserBookmarkFolder,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppDimens.width(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColor.brand400,
                            size: AppDimens.width(20),
                          ),
                          SizedBox(width: AppDimens.width(4)),
                          AppText(
                            '새 폴더',
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: AppColor.brand400,
                                  fontWeight: AppFontWeight.medium,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacerV(value: AppDimens.height(16)),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
                itemCount: bookmarkService.userBookmarkFolders.length,
                itemBuilder: (context, index) {
                  final folder = bookmarkService.userBookmarkFolders[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.height(8)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(AppDimens.radius(16)),
                        onTap: () {
                          onFolderSelected(folder.id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimens.height(12),
                            horizontal: AppDimens.width(16),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColor.graymodern700,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppDimens.radius(16)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(AppDimens.width(10)),
                                decoration: BoxDecoration(
                                  color: AppColor.brand400.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radius(12)),
                                ),
                                child: Icon(
                                  Icons.folder_rounded,
                                  color: AppColor.brand400,
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
                                            fontWeight: AppFontWeight.medium,
                                          ),
                                    ),
                                    if (folder.description != null) ...[
                                      SizedBox(height: AppDimens.height(2)),
                                      AppText(
                                        folder.description!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .textSM
                                            .copyWith(
                                              color: AppColor.graymodern500,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radius(8)),
                                  onTap: () =>
                                      showDeleteFolderConfirmationDialog(
                                    context,
                                    folder.id,
                                    folder.name,
                                    bookmarkService
                                        .onHandleDeleteUserBookmarkFolder,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimens.width(8)),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColor.rose400,
                                      size: AppDimens.width(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
