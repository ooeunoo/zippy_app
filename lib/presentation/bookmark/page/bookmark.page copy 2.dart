import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/presentation/bookmark/page/widget/bookmark-action.dialog.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService bookmarkService = Get.find();
  String selectedFolderId = UserBookmarkKey.all.name;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFolderList(context),
          Expanded(child: _buildBookmarkList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateFolderDialog(
          context,
          bookmarkService.onHandleCreateUserBookmarkFolder,
        ),
        backgroundColor: AppColor.blue500,
        child: const Icon(Icons.create_new_folder, color: AppColor.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppHeader(
      backgroundColor: AppColor.transparent,
      automaticallyImplyLeading: true,
      title: AppText(
        "저장한 콘텐츠",
        style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.gray100, fontWeight: AppFontWeight.medium),
      ),
    );
  }

  Widget _buildFolderList(BuildContext context) {
    return Container(
      height: AppDimens.height(50),
      margin: EdgeInsets.only(
        top: AppDimens.height(8),
        bottom: AppDimens.height(16),
      ),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bookmarkService.userBookmarkFolders.length + 1,
            padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildFolderItem(
                  context,
                  UserBookmarkKey.all.name,
                  UserBookmarkKey.all.name,
                  null,
                  true,
                );
              }
              final folder = bookmarkService.userBookmarkFolders[index - 1];
              return _buildFolderItem(
                context,
                folder.id,
                folder.name,
                folder.description,
                false,
              );
            },
          )),
    );
  }

  Widget _buildFolderItem(
    BuildContext context,
    String folderId,
    String name,
    String? description,
    bool isAll,
  ) {
    final isSelected = selectedFolderId == folderId;

    return Container(
      margin: EdgeInsets.only(right: AppDimens.width(8)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedFolderId = folderId;
            });
          },
          onLongPress: isAll
              ? null
              : () => showFolderOptionsDialog(
                    context,
                    folderId,
                    name,
                    bookmarkService.onHandleDeleteUserBookmarkFolder,
                  ),
          borderRadius: BorderRadius.circular(AppDimens.radius(8)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(12),
              vertical: AppDimens.height(8),
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.blue500.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColor.blue400 : AppColor.graymodern800,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radius(8)),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppDimens.width(150), // 최대 너비 제한
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAll ? Icons.folder : Icons.folder_outlined,
                    size: AppDimens.size(18),
                    color:
                        isSelected ? AppColor.blue400 : AppColor.graymodern400,
                  ),
                  AppSpacerH(value: AppDimens.width(8)),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Tooltip(
                                message: name,
                                child: AppText(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .textSM
                                      .copyWith(
                                        color: isSelected
                                            ? AppColor.blue400
                                            : AppColor.graymodern400,
                                        fontWeight: isSelected
                                            ? AppFontWeight.medium
                                            : FontWeight.normal,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (!isAll) ...[
                              AppSpacerH(value: AppDimens.width(4)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimens.width(4),
                                  vertical: AppDimens.height(1),
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.blue400
                                      : AppColor.graymodern700,
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radius(4)),
                                ),
                                child: Obx(() {
                                  final count = bookmarkService.userBookmarks
                                      .where((bookmark) =>
                                          bookmark.folderId == folderId)
                                      .length;
                                  return AppText(
                                    count.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .textXXS
                                        .copyWith(
                                          color: isSelected
                                              ? AppColor.white
                                              : AppColor.graymodern400,
                                        ),
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                        if (description != null && description.isNotEmpty) ...[
                          AppSpacerV(value: AppDimens.height(2)),
                          Tooltip(
                            message: description,
                            child: AppText(
                              description,
                              style:
                                  Theme.of(context).textTheme.textXXS.copyWith(
                                        color: isSelected
                                            ? AppColor.blue400.withOpacity(0.8)
                                            : AppColor.graymodern600,
                                      ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkList(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(
        top: AppDimens.height(8),
      ),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius(20)),
          topRight: Radius.circular(AppDimens.radius(20)),
        ),
        border: Border.all(
          color: AppColor.graymodern800,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius(20)),
          topRight: Radius.circular(AppDimens.radius(20)),
        ),
        child: Obx(() {
          final bookmarks = selectedFolderId == UserBookmarkKey.all.name
              ? bookmarkService.userBookmarks
              : bookmarkService.userBookmarks
                  .where((bookmark) => bookmark.folderId == selectedFolderId)
                  .toList();

          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: AppDimens.size(48),
                    color: AppColor.graymodern600,
                  ),
                  AppSpacerV(value: AppDimens.height(16)),
                  AppText(
                    '저장된 콘텐츠가 없습니다',
                    style: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.graymodern600,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            padding: EdgeInsets.only(top: AppDimens.height(16)),
            itemBuilder: (BuildContext context, int index) {
              final bookmark = bookmarks[index];
              final isLastItem = index == bookmarks.length - 1;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.width(5)),
                child: _buildBookmarkItem(
                  context,
                  bookmark,
                  isLastItem,
                  bookmarkService.onHandleDeleteUserBookmark,
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildBookmarkItem(
    BuildContext context,
    UserBookmark bookmark,
    bool isLastItem,
    Function delete,
  ) {
    return Slidable(
      key: ValueKey(bookmark.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) => delete(bookmark),
            backgroundColor: AppColor.rose700.withOpacity(0.9),
            foregroundColor: AppColor.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (BuildContext context) async {
              await toShare(bookmark.link, bookmark.title);
            },
            backgroundColor: AppColor.brand600.withOpacity(0.9),
            foregroundColor: AppColor.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      child: Column(
        children: [
          AppSpacerV(value: AppDimens.size(5)),
          ListTile(
            leading: SizedBox(
              height: AppDimens.size(40),
              width: AppDimens.size(40),
              child: CircleAvatar(
                radius: AppDimens.size(16),
                backgroundImage: bookmark.images != null
                    ? NetworkImage(bookmark.images!)
                    : null,
              ),
            ),
            title: AppText(
              bookmark.title.trim(),
              maxLines: 2,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern100,
                  ),
            ),
            // onTap: () => articleService.onHandleClickUserBookmark(bookmark),
            minLeadingWidth: bookmark.images != null ? 30 : 0,
          ),
          AppSpacerV(value: AppDimens.size(5)),
          if (!isLastItem) const AppDivider(),
        ],
      ),
    );
  }
}
