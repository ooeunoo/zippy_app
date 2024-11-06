import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';

void showCommentBottomSheet(
    BuildContext context, List<Map<String, String>> comments) {
  Get.bottomSheet(
    Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColor.graymodern950,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildBottomSheetHeader(context),
          _buildCommentList(context, comments),
          _buildCommentInput(context),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Widget _buildBottomSheetHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppDimens.width(20),
      vertical: AppDimens.height(15),
    ),
    decoration: const BoxDecoration(
      border:
          Border(bottom: BorderSide(color: AppColor.graymodern800, width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          "댓글",
          style: Theme.of(context).textTheme.textXL.copyWith(
                color: AppColor.graymodern100,
              ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: AppColor.graymodern100),
        ),
      ],
    ),
  );
}

Widget _buildCommentList(
    BuildContext context, List<Map<String, String>> comments) {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: comments.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppDimens.height(15)),
        child: CommentPreviewItem(
          userName: comments[index]["userName"]!,
          content: comments[index]["content"]!,
          time: comments[index]["time"]!,
        ),
      ),
    ),
  );
}

Widget _buildCommentInput(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(AppDimens.width(20)),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColor.graymodern800, width: 1)),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.graymodern100,
                ),
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
              hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.graymodern400,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColor.graymodern800),
              ),
              filled: true,
              fillColor: AppColor.graymodern900,
            ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        IconButton(
          onPressed: () {
            // 댓글 작성 로직
          },
          icon: const AppSvg(Assets.message, color: AppColor.brand600),
        ),
      ],
    ),
  );
}

class CommentPreviewItem extends StatelessWidget {
  final String userName;
  final String content;
  final String time;

  const CommentPreviewItem({
    super.key,
    required this.userName,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColor.graymodern800,
          child: AppText(
            userName[0],
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.graymodern100,
                ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    userName,
                    style: Theme.of(context).textTheme.textSM.copyWith(
                          color: AppColor.graymodern100,
                        ),
                  ),
                  AppSpacerH(value: AppDimens.width(8)),
                  AppText(
                    time,
                    style: Theme.of(context).textTheme.textXS.copyWith(
                          color: AppColor.graymodern400,
                        ),
                  ),
                ],
              ),
              AppSpacerV(value: AppDimens.height(4)),
              AppText(
                content,
                maxLines: 2, // 최대 2줄로 제한
                overflow: TextOverflow.ellipsis, // 초과시 말줄임표 표시
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern200,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
