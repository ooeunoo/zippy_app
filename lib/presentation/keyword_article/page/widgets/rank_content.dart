import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';

// 전체, 정치, 경제, 세계, 사회, 스포츠 etc

class RankContent extends StatefulWidget {
  final Function(String) onKeywordTap;

  const RankContent({
    super.key,
    required this.onKeywordTap,
  });

  @override
  State<RankContent> createState() => _RankContentState();
}

class _RankContentState extends State<RankContent>
    with TickerProviderStateMixin {
  final AppSearchController _searchController = Get.find();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _searchController.tabs.value.length + 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppDimens.width(8)),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: AppDimens.width(10),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.width(12),
                        vertical: AppDimens.height(12),
                      ),
                      child: AppText('전체',
                          style: Theme.of(context).textTheme.textSM.copyWith(
                                fontWeight: AppFontWeight.semibold,
                              )),
                    ),
                  ),
                  ..._searchController.tabs.map((type) => Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.width(12),
                            vertical: AppDimens.height(12),
                          ),
                          child: AppText(type.name,
                              style:
                                  Theme.of(context).textTheme.textSM.copyWith(
                                        fontWeight: AppFontWeight.semibold,
                                      )),
                        ),
                      )),
                ],
                labelColor: AppColor.brand400,
                unselectedLabelColor: AppThemeColors.textLow(context),
                padding: EdgeInsets.zero,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.brand400.withOpacity(0.1),
                ),
                labelStyle: Theme.of(context).textTheme.textMD.copyWith(
                      fontWeight: AppFontWeight.bold,
                    ),
                unselectedLabelStyle: Theme.of(context).textTheme.textMD,
                dividerColor: Colors.transparent,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
              )),
        ),
        AppSpacerV(value: AppDimens.height(16)),
        Expanded(
          child: Obx(() => TabBarView(
                controller: _tabController,
                children: [
                  _buildRankList(
                      context, _searchController.trendingKeywords[0] ?? []),
                  ..._searchController.tabs.map((type) {
                    final keywords =
                        _searchController.trendingKeywords[type.id];
                    if (keywords == null || keywords.isEmpty) {
                      return _buildComingSoonSection(context, type.name);
                    }

                    return _buildRankList(context,
                        _searchController.trendingKeywords[type.id] ?? []);
                  }),
                ],
              )),
        ),
        AppSpacerV(value: AppDimens.height(12)),
      ],
    );
  }

  Widget _buildComingSoonSection(BuildContext context, String category) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.articleItemBoxBackgroundColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(AppDimens.width(16)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
                size: 56, color: AppThemeColors.textLow(context)),
            AppSpacerV(value: AppDimens.height(16)),
            AppText('$category 순위 준비중',
                style: Theme.of(context).textTheme.textLG.copyWith(
                    color: AppThemeColors.textLow(context),
                    fontWeight: AppFontWeight.bold)),
            AppSpacerV(value: AppDimens.height(8)),
            AppText('곧 만나보실 수 있습니다',
                style: Theme.of(context)
                    .textTheme
                    .textSM
                    .copyWith(color: AppThemeColors.textLow(context))),
          ],
        ),
      ),
    );
  }

  Widget _buildRankList(
      BuildContext context, List<KeywordRankSnapshot> trendingKeywords) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      itemCount: trendingKeywords.length,
      itemBuilder: (context, index) {
        final item = trendingKeywords[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.height(12)),
          child: _buildRankItem(
            context,
            index + 1,
            item.keyword,
            item.descriptions ?? [],
            item.rankChange,
          ),
        );
      },
    );
  }

  Widget _buildRankItem(BuildContext context, int rank, String title,
      List<String> descriptions, int rankChange) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.articleItemBoxBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => widget.onKeywordTap(title),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.width(16)),
            child: Row(
              children: [
                _buildRankNumber(context, rank),
                AppSpacerH(value: AppDimens.width(16)),
                _buildRankItemContent(context, title, descriptions),
                _buildDeltaIndicator(context, rankChange),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankNumber(BuildContext context, int rank) {
    final color = rank == 1
        ? AppColor.orange400
        : rank == 2
            ? AppColor.yellow400
            : rank == 3
                ? AppColor.green400
                : AppColor.gray500;

    return Container(
      width: AppDimens.width(36),
      height: AppDimens.width(36),
      // decoration: BoxDecoration(
      //   color: color.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: color.withOpacity(0.2)),
      // ),
      child: Center(
        child: AppText(
          '$rank',
          style: Theme.of(context).textTheme.textLG.copyWith(
                fontWeight: AppFontWeight.bold,
                color: color,
              ),
        ),
      ),
    );
  }

  Widget _buildRankItemContent(
      BuildContext context, String title, List<String> descriptions) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppThemeColors.textHighest(context),
                  fontWeight: AppFontWeight.bold,
                  letterSpacing: -0.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeltaIndicator(BuildContext context, int rankChange) {
    if (rankChange == 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(10),
          vertical: AppDimens.height(6),
        ),
        child: AppText(
          '－',
          style: Theme.of(context).textTheme.textSM.copyWith(
                color: AppThemeColors.textLow(context),
                fontWeight: AppFontWeight.medium,
              ),
        ),
      );
    }

    final color = rankChange > 0 ? AppColor.rose400 : AppColor.blue400;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(10),
        vertical: AppDimens.height(6),
      ),
      child: AppText(
        '${rankChange > 0 ? "▲" : "▼"} ${rankChange.abs()}',
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: color,
              fontWeight: AppFontWeight.bold,
            ),
      ),
    );
  }
}
