import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';

class RankContent extends StatelessWidget {
  final TabController tabController;
  final int selectedContentTypeId;
  final List<ContentType> contentTypes;
  final Map<int, List<KeywordRankSnapshot>> trendingKeywords;
  final BuildContext parentContext;

  const RankContent({
    super.key,
    required this.tabController,
    required this.selectedContentTypeId,
    required this.contentTypes,
    required this.trendingKeywords,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLastUpdateText(),
        AppSpacerV(value: AppDimens.height(20)),
        _buildCategoryTabList(),
        AppSpacerV(value: AppDimens.height(20)),
        _buildRankList(),
      ],
    );
  }

  Widget _buildLastUpdateText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      child: AppText(
        '5분 전 업데이트',
        style: Theme.of(parentContext).textTheme.textXS.copyWith(
              color: AppColor.gray400,
            ),
      ),
    );
  }

  Widget _buildCategoryTabList() {
    return TabBar(
        padding: EdgeInsets.zero,
        controller: tabController,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.only(
          right: AppDimens.width(10),
        ),
        tabs: [
          Tab(
            iconMargin: EdgeInsets.zero,
            child: _buildCategoryTab(
              '전체',
              isActive: selectedContentTypeId == 0,
              onTap: () {
                tabController.animateTo(0);
              },
            ),
          ),
          ...contentTypes.map((ContentType contentType) {
            return Tab(
              iconMargin: EdgeInsets.zero,
              child: _buildCategoryTab(
                contentType.name,
                isActive: selectedContentTypeId == contentType.id,
                onTap: () {
                  tabController.animateTo(contentType.id);
                },
              ),
            );
          }).toList(),
        ]);
  }

  Widget _buildRankList() {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          // 전체 탭의 내용
          _buildRankListContent(trendingKeywords[0] ?? []),
          // 콘텐츠 타입별 내용
          ...contentTypes.map((ContentType contentType) {
            return _buildRankListContent(
                trendingKeywords[contentType.id] ?? []);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRankListContent(List<KeywordRankSnapshot> keywords) {
    return ListView.builder(
      itemCount: keywords.length,
      itemBuilder: (context, index) {
        final item = keywords[index];
        return _buildRankItem(
          index + 1,
          item.keyword,
          item.descriptions ?? [],
          '${item.rankChange > 0 ? "▲" : "▼"} ${item.rankChange.abs()}',
        );
      },
    );
  }

  Widget _buildCategoryTab(String text,
      {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.height(32),
        decoration: BoxDecoration(
          color: isActive ? AppColor.blue400 : AppColor.graymodern800,
          borderRadius: BorderRadius.circular(AppDimens.radius(16)),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(12), vertical: AppDimens.height(4)),
            child: AppText(
              text,
              style: Theme.of(parentContext).textTheme.textXS.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankItem(
      int rank, String title, List<String> descriptions, String delta) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(8)),
      padding: EdgeInsets.all(AppDimens.width(10)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.circular(AppDimens.radius(10)),
      ),
      child: Row(
        children: [
          _buildRankNumber(rank),
          AppSpacerH(value: AppDimens.width(20)),
          _buildRankItemContent(title, descriptions),
          _buildDeltaIndicator(delta),
        ],
      ),
    );
  }

  Widget _buildRankNumber(int rank) {
    return AppText(
      '$rank',
      style: Theme.of(parentContext).textTheme.textXL.copyWith(
            color: rank == 1
                ? AppColor.orange400
                : rank == 2
                    ? AppColor.yellow400
                    : AppColor.gray500,
          ),
    );
  }

  Widget _buildRankItemContent(String title, List<String> descriptions) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: Theme.of(parentContext).textTheme.textSM.copyWith(
                  color: Colors.white,
                ),
          ),
          AppSpacerV(value: AppDimens.height(5)),
          SizedBox(
            height: AppDimens.height(20),
            child: descriptions.isEmpty
                ? const SizedBox.shrink()
                : _buildDescriptionMarquee(descriptions),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionMarquee(List<String> descriptions) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: descriptions.length - 1),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return AppText(
          descriptions[value],
          style: Theme.of(parentContext).textTheme.textXS.copyWith(
                color: AppColor.gray400,
              ),
        );
      },
      onEnd: () {
        // Animation completed, restart with next description
      },
    );
  }

  Widget _buildDeltaIndicator(String delta) {
    return AppText(
      delta,
      style: Theme.of(parentContext).textTheme.textXS.copyWith(
            fontSize: 14,
            color: delta.startsWith('▲') ? AppColor.blue400 : AppColor.rose400,
          ),
    );
  }
}
