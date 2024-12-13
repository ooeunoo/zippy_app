import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';

class RankContent extends StatelessWidget {
  final List<KeywordRankSnapshot> trendingKeywords;
  final Function(String) onKeywordTap;

  const RankContent({
    super.key,
    required this.trendingKeywords,
    required this.onKeywordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRankList(context),
      ],
    );
  }

  Widget _buildRankList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: trendingKeywords.length,
        itemBuilder: (context, index) {
          final item = trendingKeywords[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(12),
              vertical: AppDimens.height(4),
            ),
            child: _buildRankItem(
              context,
              index + 1,
              item.keyword,
              item.descriptions ?? [],
              item.rankChange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRankItem(BuildContext context, int rank, String title,
      List<String> descriptions, int rankChange) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppThemeColors.articleItemBoxBackgroundColor(context),
      child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onKeywordTap(title),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppDimens.width(8)),
            padding: EdgeInsets.all(AppDimens.width(18)),
            child: Row(
              children: [
                AppSpacerH(value: AppDimens.width(4)),
                _buildRankNumber(context, rank),
                AppSpacerH(value: AppDimens.width(20)),
                _buildRankItemContent(context, title, descriptions),
                _buildDeltaIndicator(context, rankChange),
                AppSpacerH(value: AppDimens.width(4)),
              ],
            ),
          )),
    );
  }

  Widget _buildRankNumber(BuildContext context, int rank) {
    return AppText(
      '$rank',
      style: Theme.of(context).textTheme.textXL.copyWith(
            fontWeight: AppFontWeight.medium,
            color: rank == 1
                ? AppColor.orange400
                : rank == 2
                    ? AppColor.yellow400
                    : rank == 3
                        ? AppColor.green400
                        : AppColor.gray500,
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
                  fontWeight: AppFontWeight.semibold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeltaIndicator(BuildContext context, int rankChange) {
    if (rankChange == 0) {
      return AppText(
        '－',
        style: Theme.of(context).textTheme.textMD.copyWith(
              color: AppThemeColors.textLow(context),
            ),
      );
    }
    return AppText(
      '${rankChange > 0 ? "▲" : "▼"} ${rankChange.abs()}',
      style: Theme.of(context).textTheme.textMD.copyWith(
            color: rankChange > 0 ? AppColor.rose400 : AppColor.blue400,
          ),
    );
  }
}
