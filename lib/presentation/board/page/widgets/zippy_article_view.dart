import 'package:flutter/material.dart';
import 'package:highlightable_text/highlightable_text.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
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
        floatingActionButton: _buildFloatingButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              AppSpacerV(value: AppDimens.height(150)),
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
                '이것만 알면 끝!',
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
      child: Column(
        children: [
          Row(
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
          AppSpacerV(value: AppDimens.height(5)),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: AppDimens.width(8)),
              height: AppDimens.height(48),
              child: FloatingActionButton.extended(
                heroTag: 'summary',
                backgroundColor: AppColor.brand600,
                onPressed: () {
                  // 요약보기 처리
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.summarize_rounded,
                      color: AppColor.gray50,
                      size: 20,
                    ),
                    AppSpacerH(value: AppDimens.width(8)),
                    AppText(
                      '요약보기',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppColor.gray50,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: AppDimens.width(8)),
              height: AppDimens.height(48),
              child: FloatingActionButton.extended(
                heroTag: 'original',
                backgroundColor: AppColor.gray700,
                onPressed: () {
                  // 원문보기 처리
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.article_rounded,
                      color: AppColor.gray50,
                      size: 20,
                    ),
                    AppSpacerH(value: AppDimens.width(8)),
                    AppText(
                      '원문보기',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppColor.gray50,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
