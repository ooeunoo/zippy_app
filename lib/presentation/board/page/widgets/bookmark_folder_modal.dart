import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zippy/app/services/article.service.dart';
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
    final articleService = Get.find<ArticleService>();

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
                onPressed: () => _showCreateFolderDialog(context),
              ),
            ],
          ),
          AppSpacerV(value: AppDimens.height(12)),
          Expanded(
            child: Obx(() {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: articleService.userBookmarkFolders.length,
                separatorBuilder: (_, __) => Divider(
                  color: AppColor.graymodern700,
                  height: AppDimens.height(1),
                ),
                itemBuilder: (context, index) {
                  final folder = articleService.userBookmarkFolders[index];
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
                            onPressed: () =>
                                _showDeleteFolderDialog(context, folder),
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

  void _showCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateBookmarkFolderDialog(),
    );
  }

  void _showDeleteFolderDialog(
      BuildContext context, UserBookmarkFolder folder) {
    showAppDialog(
      "폴더 삭제",
      message: '정말로 "${folder.name}" 폴더를 삭제하시겠습니까?',
      onConfirm: () async {
        final articleService = Get.find<ArticleService>();
        await articleService.onHandleDeleteUserBookmarkFolder(folder);
      },
    );
  }
}

class CreateBookmarkFolderDialog extends StatefulWidget {
  const CreateBookmarkFolderDialog({super.key});

  @override
  State<CreateBookmarkFolderDialog> createState() =>
      _CreateBookmarkFolderDialogState();
}

class _CreateBookmarkFolderDialogState
    extends State<CreateBookmarkFolderDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final articleService = Get.find<ArticleService>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.graymodern900,
      title: AppText(
        '새 폴더 만들기',
        style: Theme.of(context).textTheme.textLG.copyWith(
              color: AppColor.graymodern100,
              fontWeight: AppFontWeight.bold,
            ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern200,
                  ),
              decoration: InputDecoration(
                hintText: '폴더 이름',
                hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern500,
                    ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.graymodern700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.blue400),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '폴더 이름을 입력해주세요';
                }
                return null;
              },
            ),
            AppSpacerV(value: AppDimens.height(16)),
            TextFormField(
              controller: _descriptionController,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern200,
                  ),
              decoration: InputDecoration(
                hintText: '설명 (선택사항)',
                hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern500,
                    ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.graymodern700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.blue400),
                ),
              ),
            ),
          ],
        ),
      ),
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
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final folder = UserBookmarkFolder(
                id: const Uuid().v4(),
                name: _nameController.text,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                createdAt: DateTime.now(),
              ).toCreateEntity();

              await articleService.createUserBookmarkFolder.execute(folder);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: AppText(
            '만들기',
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.blue400,
                  fontWeight: AppFontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
