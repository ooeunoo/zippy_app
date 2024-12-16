import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/bookmark/page/widget/bookmark-action.dialog.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

const int ALL_FOLDER_ID = 0;

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService bookmarkService = Get.find();
  final ArticleService articleService = Get.find();

  int selectedFolderId = ALL_FOLDER_ID;

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
          AppSpacerV(value: AppDimens.height(12)),
          _buildFolderInfo(context), // 추가된 부분
          AppSpacerV(value: AppDimens.height(12)),
          Expanded(child: _buildBookmarkList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateFolderDialog(
          context,
          bookmarkService.onHandleCreateUserBookmarkFolder,
        ),
        backgroundColor: AppThemeColors.buttonBackgroundColor(context),
        child: const Icon(Icons.create_new_folder, color: AppColor.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppHeaderWrap(
      child: AppHeader(
        backgroundColor: AppColor.transparent,
        automaticallyImplyLeading: true,
        title: AppText(
          "저장한 콘텐츠",
          style: Theme.of(context).textTheme.textMD.copyWith(
                color: AppThemeColors.textHigh(context),
                fontWeight: AppFontWeight.medium,
              ),
        ),
      ),
    );
  }

  Widget _buildFolderList(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppDimens.height(45),
          margin: EdgeInsets.only(
            top: AppDimens.height(8),
          ),
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bookmarkService.userBookmarkFolders.length + 1,
                padding: EdgeInsets.symmetric(horizontal: AppDimens.width(12)),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildTabItem(
                      context,
                      0,
                      '전체 보기',
                      null,
                      true,
                    );
                  }
                  final folder = bookmarkService.userBookmarkFolders[index - 1];
                  return _buildTabItem(
                    context,
                    folder.id,
                    folder.name,
                    folder.description,
                    false,
                  );
                },
              )),
        ),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    int folderId,
    String name,
    String? description,
    bool isAll,
  ) {
    final isSelected = selectedFolderId == folderId;
    final displayName = name.length > 10 ? '${name.substring(0, 10)}...' : name;

    return Container(
      margin: EdgeInsets.only(right: AppDimens.width(4)),
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
                    (int id) async {
                      await bookmarkService
                          .onHandleDeleteUserBookmarkFolder(id);
                      setState(() {
                        selectedFolderId = ALL_FOLDER_ID;
                      });
                    },
                  ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(7),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: AppDimens.size(16),
                      color: isSelected
                          ? AppColor.brand400
                          : AppColor.graymodern600,
                    ),
                    AppSpacerH(value: AppDimens.width(8)),
                    Tooltip(
                      message:
                          '$name${description != null ? '\n$description' : ''}',
                      child: AppText(
                        displayName,
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: isSelected
                                  ? AppColor.brand400
                                  : AppColor.graymodern600,
                              fontWeight: isSelected
                                  ? AppFontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.brand400.withOpacity(0.5),
                            AppColor.brand400,
                            AppColor.brand400.withOpacity(0.5),
                          ],
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
  }

  Widget _buildFolderInfo(BuildContext context) {
    return Obx(() {
      final description = selectedFolderId == ALL_FOLDER_ID
          ? "저장된 모든 콘텐츠"
          : bookmarkService.userBookmarkFolders
              .firstWhere((folder) => folder.id == selectedFolderId)
              .description;

      final bookmarkCount = selectedFolderId == ALL_FOLDER_ID
          ? bookmarkService.userBookmarks.length
          : bookmarkService.userBookmarks
              .where((bookmark) => bookmark.folderId == selectedFolderId)
              .length;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: AppDimens.width(200), // description의 최대 너비 제한
              child: AppText(
                description ?? '',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppThemeColors.textLow(context),
                      height: 1.3,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppText(
              '$bookmarkCount개',
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppThemeColors.textLow(context),
                  ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBookmarkList(BuildContext context) {
    return Obx(() {
      final bookmarks = selectedFolderId == ALL_FOLDER_ID
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
                size: AppDimens.size(32),
                color: AppThemeColors.iconColor(context),
              ),
              AppSpacerV(value: AppDimens.height(16)),
              AppText(
                '저장된 콘텐츠가 없습니다',
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppThemeColors.textHigh(context),
                    ),
              ),
              AppSpacerV(value: AppDimens.height(150)),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: bookmarks.length,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(8)),
        itemBuilder: (BuildContext context, int index) {
          final bookmark = bookmarks[index];
          return ArticleRowItem(
            article: bookmark.article!,
            onHandleClickArticle: () {
              articleService.onHandleGoToArticleView(bookmark.article!);
            },
          );
        },
      );
    });
  }
}
