import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/presentation/bookmark/controller/bookmark.controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}


class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    BookmarkController controller = Get.find();
    return Scaffold(
        appBar: appBar(context),
        body: Padding(
          padding: EdgeInsets.only(top: AppDimens.height(20)),
          child: bookmarkLists(context, controller),
        ));
  }

  PreferredSizeWidget appBar(BuildContext context) {
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


  Widget bookmarkLists(BuildContext context, BookmarkController controller) {
    return Obx(() => ListView.builder(
          itemCount: controller.userBookmarks.length,
          itemBuilder: (BuildContext context, int index) {
            return Obx(() {
              UserBookmark bookmark = controller.userBookmarks[index];
              bool isLastItem = index == controller.userBookmarks.length - 1;
              var deleteAction = controller.deleteBookmarkContent;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.width(5)),
                child: bookmarkItems(
                    context, controller, bookmark, isLastItem, deleteAction),
              );
            });
          },
        ));
  }

  Widget bookmarkItems(BuildContext context, BookmarkController controller,
      UserBookmark bookmark, bool isLastItem, delete) {
    return Slidable(
        key: const ValueKey(0),
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
        child: Column(children: [
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
              style: Theme.of(context)
                  .textTheme
                  .textMD
                  .copyWith(color: AppColor.graymodern100),
            ),
            onTap: () => controller.onClickBookmark(bookmark),
            minLeadingWidth: bookmark.images != null ? 30 : 0,
          ),
          AppSpacerV(value: AppDimens.size(5)),
          if (!isLastItem) const AppDivider(),
        ]));
  }
}
