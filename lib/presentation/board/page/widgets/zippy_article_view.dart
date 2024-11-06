import 'dart:math';

import 'package:flutter/material.dart';
import 'package:highlightable_text/highlightable_text.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
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
    print('duration: ${duration.inSeconds}');
    widget.handleUpdateUserInteraction?.call(0, duration.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColor.gray900,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppHeader(
      backgroundColor: AppColor.gray800,
      title: AppText(
        widget.article.title,
        maxLines: 1,
        style: Theme.of(context).textTheme.textLG.copyWith(
              color: AppColor.gray50,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColor.gray800,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(16),
            child: _buildArticleContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(),
        const AppSpacerV(value: 20),
        _buildMetaInfo(),
        const AppSpacerV(value: 24),
        _buildKeywords(),
        const AppSpacerV(value: 24),
        _buildSummary(),
        const AppSpacerV(value: 24),
        _buildKeyPoints(),
        const AppSpacerV(value: 24),
        _buildContent(),
      ],
    );
  }

  Widget _buildImage() {
    if (widget.article.images.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.article.images[0]!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    if (widget.article.subtitle == null) return const SizedBox.shrink();

    return AppText(
      widget.article.subtitle!,
      style: Theme.of(context).textTheme.textSM.copyWith(
            color: AppColor.gray100,
            height: 1.5,
          ),
    );
  }

  Widget _buildMetaInfo() {
    final textStyle = Theme.of(context).textTheme.textSM.copyWith(
          color: AppColor.gray400,
        );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.gray700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColor.gray300),
              const SizedBox(width: 8),
              AppText(
                widget.article.author,
                style: textStyle,
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColor.gray300),
              const SizedBox(width: 8),
              AppText(
                widget.article.published.timeAgo(),
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeywords() {
    if (widget.article.keywords == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.article.keywords!
          .map((keyword) => _buildKeywordChip(keyword))
          .toList(),
    );
  }

  Widget _buildKeywordChip(String keyword) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.brand600.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.brand600.withOpacity(0.3)),
      ),
      child: AppText(
        keyword,
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: AppColor.brand600,
            ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.gray700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Summary",
            style: Theme.of(context).textTheme.textLG.copyWith(
                  color: AppColor.gray50,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (widget.article.summary != null)
            AppText(
              widget.article.summary!,
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.gray200,
                    height: 1.6,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints() {
    if (widget.article.keyPoints == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.gray700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Key Points",
            style: Theme.of(context).textTheme.textLG.copyWith(
                  color: AppColor.gray50,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...widget.article.keyPoints!.map(_buildKeyPoint),
        ],
      ),
    );
  }

  Widget _buildKeyPoint(String point) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: AppColor.brand600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              point,
              style: Theme.of(context).textTheme.textSM.copyWith(
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.gray700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Content",
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
      textStyle: Theme.of(context).textTheme.textSM.copyWith(
            color: AppColor.gray200,
            height: 1.6,
          ),
      highlightColor: AppColor.brand600.withOpacity(0.2),
      onHighlight: _handleHighlight,
      onDeleteHighlight: _handleDeleteHighlight,
      onSaveNote: _handleSaveNote,
      menuBuilder: (context, highlight, onHighlight, onNote, onDelete) =>
          _buildHighlightMenu(
        context,
        highlight,
        onHighlight,
        onNote,
        onDelete,
      ),
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
