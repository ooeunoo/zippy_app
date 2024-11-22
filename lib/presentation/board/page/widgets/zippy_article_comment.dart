import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/presentation/login/page/login.page.dart';

void showCommentBottomSheet(
    BuildContext context,
    int articleId,
    Function(int articleId) onHandleGetArticleComments,
    Function(CreateArticleCommentParams) onHandleCreateArticleComment) {
  Get.bottomSheet(
    ZippyArticleComment(
        articleId: articleId,
        onHandleGetArticleComments: onHandleGetArticleComments,
        onHandleCreateArticleComment: onHandleCreateArticleComment),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class ZippyArticleComment extends StatefulWidget {
  final int articleId;
  final Function(int articleId) onHandleGetArticleComments;
  final Function(CreateArticleCommentParams) onHandleCreateArticleComment;

  const ZippyArticleComment(
      {super.key,
      required this.articleId,
      required this.onHandleGetArticleComments,
      required this.onHandleCreateArticleComment});

  @override
  State<ZippyArticleComment> createState() => _ZippyArticleCommentState();
}

class _ZippyArticleCommentState extends State<ZippyArticleComment> {
  final AuthService authService = Get.find<AuthService>();
  List<ArticleComment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  ArticleComment? replyingTo; // 대댓글 작성 시 부모 댓글 저장

  @override
  void initState() {
    super.initState();
    _handleFetchArticleComments(widget.articleId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleFetchArticleComments(int articleId) async {
    final result = await widget.onHandleGetArticleComments(articleId);
    setState(() {
      comments = result;
    });
  }

  void _handleSubmitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await widget.onHandleCreateArticleComment(
      CreateArticleCommentParams(
        articleId: widget.articleId,
        authorId: authService.currentUser.value!.id,
        content: _commentController.text,
        parentId: replyingTo?.id,
      ),
    );

    _commentController.clear();
    setState(() => replyingTo = null);
    await _handleFetchArticleComments(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      BuildContext context, List<ArticleComment> comments) {
    // 최상위 댓글만 필터링
    final topLevelComments = comments.where((c) => c.parentId == null).toList();

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimens.width(20)),
        itemCount: topLevelComments.length,
        itemBuilder: (context, index) {
          final comment = topLevelComments[index];
          // 해당 댓글의 대댓글들 찾기
          final replies =
              comments.where((c) => c.parentId == comment.id).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommentItem(
                comment: comment,
                onReply: () => setState(() => replyingTo = comment),
              ),
              if (replies.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: AppDimens.width(40)),
                  child: Column(
                    children: replies
                        .map((reply) => Padding(
                              padding:
                                  EdgeInsets.only(top: AppDimens.height(10)),
                              child: CommentItem(
                                comment: reply,
                                isReply: true,
                                onReply: () =>
                                    setState(() => replyingTo = comment),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              AppSpacerV(value: AppDimens.height(15)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    // 로그인하지 않은 경우
    if (!authService.isLoggedIn.value) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.width(20)),
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: AppColor.graymodern800, width: 1)),
              color: AppColor.graymodern950,
            ),
            child: InkWell(
              onTap: () => Get.toNamed(Routes.login),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimens.height(12),
                ),
                decoration: BoxDecoration(
                  color: AppColor.graymodern900,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.graymodern800),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.width(16),
                  ),
                  child: AppText(
                    "🔒 로그인 후 댓글을 작성할 수 있습니다",
                    style: Theme.of(context).textTheme.textMD.copyWith(
                          color: AppColor.graymodern400,
                        ),
                  ),
                ),
              ),
            ),
          ),
          AppSpacerV(value: AppDimens.height(15)),
        ],
      );
    }

    // 로그인한 경우 기존 댓글 입력 UI
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppDimens.width(20)),
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: AppColor.graymodern800, width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replyingTo != null)
                Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.height(8)),
                  child: Row(
                    children: [
                      AppText(
                        '${replyingTo!.author?.name ?? "익명"}님에게 답글 작성 중',
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.graymodern400,
                            ),
                      ),
                      AppSpacerH(value: AppDimens.width(8)),
                      GestureDetector(
                        onTap: () => setState(() => replyingTo = null),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColor.graymodern400,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppColor.graymodern100,
                          ),
                      decoration: InputDecoration(
                        hintText:
                            replyingTo == null ? "댓글을 입력하세요" : "답글을 입력하세요",
                        hintStyle: Theme.of(context).textTheme.textMD.copyWith(
                              color: AppColor.graymodern400,
                            ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: AppColor.graymodern800),
                        ),
                        filled: true,
                        fillColor: AppColor.graymodern900,
                      ),
                    ),
                  ),
                  AppSpacerH(value: AppDimens.width(10)),
                  IconButton(
                    onPressed: _handleSubmitComment,
                    icon:
                        const AppSvg(Assets.message, color: AppColor.brand600),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppSpacerV(value: AppDimens.height(15)),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final ArticleComment comment;
  final bool isReply;
  final VoidCallback onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReply)
          Padding(
            padding: EdgeInsets.only(right: AppDimens.width(8)),
            child: const Icon(
              Icons.subdirectory_arrow_right,
              size: 16,
              color: AppColor.graymodern600,
            ),
          ),
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColor.graymodern800,
          child: AppText(
            (comment.author?.name ?? "익명")[0],
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
                    comment.author?.name ?? "익명",
                    style: Theme.of(context).textTheme.textSM.copyWith(
                          color: AppColor.graymodern100,
                        ),
                  ),
                  AppSpacerH(value: AppDimens.width(8)),
                  AppText(
                    comment.createdAt.timeAgo(),
                    style: Theme.of(context).textTheme.textXS.copyWith(
                          color: AppColor.graymodern400,
                        ),
                  ),
                ],
              ),
              AppSpacerV(value: AppDimens.height(4)),
              AppText(
                comment.content,
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.graymodern200,
                    ),
              ),
              // 대댓글이 아닐 때만 답글달기 버튼 표시
              if (!isReply) ...[
                AppSpacerV(value: AppDimens.height(4)),
                GestureDetector(
                  onTap: onReply,
                  child: AppText(
                    "답글달기",
                    style: Theme.of(context).textTheme.textXS.copyWith(
                          color: AppColor.brand600,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
