import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';

class RankingItem {
  final int rank;
  final String keyword;
  final int change;

  RankingItem({
    required this.rank,
    required this.keyword,
    required this.change,
  });
}

class KeywordRankingsSection extends StatefulWidget {
  const KeywordRankingsSection({
    super.key,
  });

  @override
  State<KeywordRankingsSection> createState() => _KeywordRankingsSectionState();
}

class _KeywordRankingsSectionState extends State<KeywordRankingsSection>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  int currentRankingIndex = 0;
  late Timer _timer;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<RankingItem> rankings = [
    RankingItem(rank: 1, keyword: '삼성전자', change: 2),
    RankingItem(rank: 2, keyword: '애플', change: -1),
    RankingItem(rank: 3, keyword: 'LG에너지솔루션', change: 0),
    RankingItem(rank: 4, keyword: 'SK하이닉스', change: 3),
    RankingItem(rank: 5, keyword: '현대차', change: -2),
    RankingItem(rank: 6, keyword: '카카오', change: 1),
    RankingItem(rank: 7, keyword: '네이버', change: -1),
    RankingItem(rank: 8, keyword: '기아', change: 4),
    RankingItem(rank: 9, keyword: 'LG전자', change: -2),
    RankingItem(rank: 10, keyword: '포스코', change: 0),
  ];
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      rankings.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    }).toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!isExpanded) {
        setState(() {
          currentRankingIndex = (currentRankingIndex + 1) % rankings.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      isExpanded = !isExpanded;
      if (!isExpanded) {
        _startTimer();
        for (var controller in _controllers) {
          controller.reverse();
        }
      } else {
        _timer.cancel();
        for (var controller in _controllers) {
          controller.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 480 : 60,
            child: Column(
              children: [
                _buildRankingHeader(),
                if (isExpanded)
                  Expanded(
                    child: _buildRankingList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(16),
      ),
      child: !isExpanded ? _buildCollapsedHeader() : _buildExpandedHeader(),
    );
  }

  Widget _buildCollapsedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(8),
            vertical: AppDimens.height(4),
          ),
          decoration: BoxDecoration(
            color: AppColor.brand800,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(Icons.trending_up,
                  color: AppColor.white, size: AppDimens.size(16)),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                'Live',
                style: Theme.of(context)
                    .textTheme
                    .textSM
                    .copyWith(color: AppColor.white),
              ),
            ],
          ),
        ),
        AppSpacerH(value: AppDimens.width(12)),
        Expanded(
          child: _buildSingleRanking(rankings[currentRankingIndex]),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildExpandedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "실시간 인기 검색어",
              style: Theme.of(context)
                  .textTheme
                  .textSM
                  .copyWith(color: AppColor.white),
            ),
            AppText(
              "오늘 11:11 기준",
              style: Theme.of(context)
                  .textTheme
                  .textXS
                  .copyWith(color: AppColor.graymodern400),
            ),
          ],
        ),
        const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return ScaleTransition(
          scale: _animations[index],
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(_animations[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildSingleRanking(rankings[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleRanking(RankingItem ranking) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '${ranking.rank}',
            style: TextStyle(
              color: ranking.rank <= 3 ? Colors.amber : Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            ranking.keyword,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        _buildChangeIndicator(ranking.change),
      ],
    );
  }

  Widget _buildChangeIndicator(int change) {
    if (change == 0) {
      return const Text(
        '-',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
          color: change > 0 ? Colors.red : Colors.blue,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          change.abs().toString(),
          style: TextStyle(
            color: change > 0 ? Colors.red : Colors.blue,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
