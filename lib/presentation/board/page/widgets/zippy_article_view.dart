import 'package:flutter/material.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;
  const ZippyArticleView({
    super.key,
    required this.article,
  });

  @override
  State<ZippyArticleView> createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> with RouteAware {
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime!);
    print('페이지 체류 시간: ${_formatDuration(duration)}초');
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    return duration.inSeconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final duration = DateTime.now().difference(_startTime!);
        print('페이지 체류 시간: ${_formatDuration(duration)}초');
        return true;
      },
      child: Scaffold(
        appBar: AppHeader(
          title: AppText(
            widget.article.title,
            style: Theme.of(context).textTheme.textLG.copyWith(
                  color: AppColor.gray100,
                ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubtitle(),
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildMetaInfo(),
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildKeywords(),
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildSummary(),
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildKeyPoints(),
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.article.images.isNotEmpty) {
      return Image.network(
        widget.article.images[0]!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildSubtitle() {
    if (widget.article.subtitle != null) {
      return AppText(
        widget.article.subtitle!,
        style: Theme.of(context).textTheme.textSM,
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildMetaInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          "By ${widget.article.author}",
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.gray300,
              ),
        ),
        AppText(
          widget.article.published.timeAgo(),
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppColor.gray300,
              ),
        ),
      ],
    );
  }

  Widget _buildKeywords() {
    return Wrap(
      spacing: 8,
      children: widget.article.keywords
              ?.map((keyword) => Chip(
                    label: AppText(
                      keyword,
                      style: Theme.of(context).textTheme.textSM,
                    ),
                  ))
              .toList() ??
          [],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Summary",
          style: Theme.of(context).textTheme.textLG,
        ),
        if (widget.article.summary != null)
          AppText(
            widget.article.summary!,
            style: Theme.of(context).textTheme.textSM,
          ),
      ],
    );
  }

  Widget _buildKeyPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Key Points",
          style: Theme.of(context).textTheme.textLG,
        ),
        Column(
          children: widget.article.keyPoints
                  ?.map((point) => ListTile(
                        leading: Icon(Icons.arrow_right),
                        title: AppText(
                          point,
                          style: Theme.of(context).textTheme.textSM,
                        ),
                      ))
                  .toList() ??
              [],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Content",
          style: Theme.of(context).textTheme.textLG,
        ),
        AppText(
          widget.article.content,
          style: Theme.of(context).textTheme.textSM,
        ),
      ],
    );
  }
}
