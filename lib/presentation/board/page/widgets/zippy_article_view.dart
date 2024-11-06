import 'dart:math';

import 'package:flutter/material.dart';
import 'package:highlightable_text/highlightable_text.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_highlight_menu.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:highlightable_text/highlightable_text.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_highlight_menu.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;
  final Function(int, int)? handleUpdateUserInteraction;

  const ZippyArticleView({
    super.key,
    required this.article,
    this.handleUpdateUserInteraction,
  });

  @override
  State<ZippyArticleView> createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> with RouteAware {
  DateTime? _startTime;
  final List<Highlight> _highlights = [];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _handleUserInteraction();
    super.dispose();
  }

  void _handleUserInteraction() {
    final duration = DateTime.now().difference(_startTime!);
    widget.handleUpdateUserInteraction?.call(0, duration.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) _handleUserInteraction();
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.article.images.isNotEmpty) ...[
                _buildImage(),
                AppSpacerV(value: AppDimens.height(10)),
              ],
              _buildEngagementSection(),
              AppSpacerV(value: AppDimens.height(15)),
              const AppDivider(color: AppColor.gray600, height: 5),
              AppSpacerV(value: AppDimens.height(15)),
              _buildKeyPoints(),
              // _buildTLDR(),
              // _buildContent(),
              // AppSpacerV(value: AppDimens.height(20)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      leading: const BackButton(color: AppColor.gray50),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: AppColor.gray50),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColor.gray50),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTLDR() {
    if (widget.article.summary == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColor.brand600.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppText(
                  '요약',
                  style: Theme.of(context).textTheme.textXS.copyWith(
                        color: AppColor.brand600,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const AppSpacerV(value: 12),
          AppText(
            widget.article.summary!,
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.gray200,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.article.images[0]!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEngagementSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            widget.article.title,
            style: Theme.of(context).textTheme.textXL.copyWith(
                  color: AppColor.gray50,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
          ),
          AppSpacerV(value: AppDimens.height(12)),
          Row(
            children: [
              const Icon(Icons.remove_red_eye,
                  size: 16, color: AppColor.gray400),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                '2.4k reads',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
              AppSpacerH(value: AppDimens.width(16)),
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: AppColor.gray400),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                '42 comments',
                style: Theme.of(context).textTheme.textSM.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints() {
    if (widget.article.keyPoints == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColor.brand600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppDimens.width(8)),
              AppText(
                '이것만 읽으면 돼!',
                style: Theme.of(context).textTheme.textLG.copyWith(
                      color: AppColor.gray50,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.height(16)),
          ...widget.article.keyPoints!.map((point) => _buildKeyPoint(point)),
        ],
      ),
    );
  }

  Widget _buildKeyPoint(String point) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.height(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // center로 변경
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppDimens.height(5)), // 미세 조정
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 16,
              color: AppColor.brand600,
            ),
          ),
          AppSpacerH(value: AppDimens.width(4)),
          Expanded(
            child: AppText(
              point,
              maxLines: 2,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppColor.gray200,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.gray800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Full Article',
            style: Theme.of(context).textTheme.textLG.copyWith(
                  color: AppColor.gray50,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildHighlightableContent(),
        ],
      ),
    );
  }

  Widget _buildHighlightableContent() {
    return HighlightableText(
      text: widget.article.formattedContent,
      initialHighlights: _highlights,
      textStyle: Theme.of(context).textTheme.textMD.copyWith(
            color: AppColor.gray200,
            height: 1.6,
          ),
      highlightColor: AppColor.brand600.withOpacity(0.2),
      onHighlight: _handleHighlight,
      onDeleteHighlight: _handleDeleteHighlight,
      onSaveNote: _handleSaveNote,
      menuBuilder: _buildHighlightMenu,
      noteIndicatorBuilder: _buildNoteIndicator,
    );
  }

  void _handleHighlight(String content, int startOffset, int endOffset) {
    print('highlight: $content, $startOffset, $endOffset');
  }

  void _handleDeleteHighlight(Highlight highlight) {
    print('delete highlight: ${highlight.id}');
  }

  void _handleSaveNote(Highlight highlight, String note) {
    print('note: $note');
    setState(() {
      final index = _highlights.indexWhere(
        (h) =>
            h.startOffset == highlight.startOffset &&
            h.endOffset == highlight.endOffset,
      );
      if (index != -1) {
        _highlights[index] = highlight.copyWith(note: note);
      }
    });
  }

  Widget _buildHighlightMenu(
    BuildContext context,
    Highlight? highlight,
    VoidCallback onHighlight,
    VoidCallback onNote,
    VoidCallback onDelete,
  ) {
    return AppHighlightMenu(
      highlight: highlight,
      onHighlight: onHighlight,
      onNote: onNote,
      onDelete: onDelete,
    );
  }

  Widget _buildNoteIndicator(Highlight highlight) {
    if (highlight.note?.isEmpty ?? true) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 5),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Icon(
          Icons.mode_comment_rounded,
          size: 16,
          color: highlight.note?.isNotEmpty == true
              ? AppColor.brand600
              : AppColor.gray400,
        ),
      ),
    );
  }
}
