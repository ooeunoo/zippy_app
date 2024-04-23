import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_webview.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/presentation/controllers/bookmark/bookmark_controller.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    BookmarkController controller = Get.find();

    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20), vertical: AppDimens.height(10)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [bookmarkLists(context, controller)],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Container(),
      leadingWidth: AppDimens.width(5),
      title: AppText("저장한 콘텐츠",
          style: Theme.of(context)
              .textTheme
              .displayXS
              .copyWith(color: AppColor.gray100)),
    );
  }

  Widget bookmarkLists(BuildContext context, BookmarkController controller) {
    return Obx(() => Expanded(
          child: ListView.builder(
              itemCount: controller.bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                Bookmark bookmark = controller.bookmarks[index];
                bool isLastItem = index == controller.bookmarks.length - 1;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.height(5)),
                  child: bookmarkItems(context, bookmark, isLastItem),
                );
              }),
        ));
  }

  Widget bookmarkItems(
      BuildContext context, Bookmark bookmark, bool isLastItem) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: AppDimens.size(40),
            width: AppDimens.size(40),
            child: CircleAvatar(
              radius: AppDimens.size(16),
              backgroundImage: bookmark.item?.contentImgUrl != null
                  ? NetworkImage(bookmark.item!.contentImgUrl!)
                  : null,
            ),
          ),
          title: AppText(
            bookmark.item?.title ?? '',
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .textMD
                .copyWith(color: AppColor.graymodern100),
          ),
          onTap: () {
            if (bookmark.item?.url != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppWebview(
                            uri: bookmark.item!.url,
                          )));
            }
          },
          minLeadingWidth: bookmark.item?.contentImgUrl != null ? 56 : 0,
        ),
        const AppSpacerV(),
        if (!isLastItem) const AppDivider(),
      ],
    );
  }
}
