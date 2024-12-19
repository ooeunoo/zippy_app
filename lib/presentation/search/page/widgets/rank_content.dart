import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';

class RankContent extends StatefulWidget {
  final List<KeywordRankSnapshot> trendingKeywords;
  final Function(String) onKeywordTap;

  const RankContent({
    super.key,
    required this.trendingKeywords,
    required this.onKeywordTap,
  });

  @override
  State<RankContent> createState() => _RankContentState();
}

class _RankContentState extends State<RankContent> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['전체', '정치', '경제'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
          margin: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
          decoration: BoxDecoration(
            color: AppThemeColors.articleItemBoxBackgroundColor(context),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            tabs: _tabs.map((tab) => Tab(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.width(16),
                  vertical: AppDimens.height(8),
                ),
                child: Text(tab),
              ),
            )).toList(),
            labelColor: AppColor.orange400,
            unselectedLabelColor: AppThemeColors.textLow(context),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.orange400.withOpacity(0.1),
            ),
            labelStyle: Theme.of(context).textTheme.textMD.copyWith(
              fontWeight: AppFontWeight.bold,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.textMD,
            dividerColor: Colors.transparent,
          ),
        ),
        AppSpacerV(value: AppDimens.height(16)),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRankList(context),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.construction, 
                      size: 48, 
                      color: AppThemeColors.textLow(context)
                    ),
                    AppSpacerV(value: AppDimens.height(8)),
                    AppText('정치 순위 준비중', 
                      style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppThemeColors.textLow(context)
                      )
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.construction, 
                      size: 48, 
                      color: AppThemeColors.textLow(context)
                    ),
                    AppSpacerV(value: AppDimens.height(8)),
                    AppText('경제 순위 준비중', 
                      style: Theme.of(context).textTheme.textMD.copyWith(
                        color: AppThemeColors.textLow(context)
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacerV(value: AppDimens.height(12)),
      ],
    );
  }

  Widget _buildRankList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
      itemCount: widget.trendingKeywords.length,
      itemBuilder: (context, index) {
        final item = widget.trendingKeywords[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.height(8)),
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
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppThemeColors.articleItemBoxBackgroundColor(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onKeywordTap(title),
        child: Container(
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
      width: AppDimens.width(32),
      height: AppDimens.width(32),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
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
          horizontal: AppDimens.width(8),
          vertical: AppDimens.height(4),
        ),
        decoration: BoxDecoration(
          color: AppThemeColors.textLow(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
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
        horizontal: AppDimens.width(8),
        vertical: AppDimens.height(4),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        '${rankChange > 0 ? "▲" : "▼"} ${rankChange.abs()}',
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: color,
              fontWeight: AppFontWeight.medium,
            ),
      ),
    );
  }
}
