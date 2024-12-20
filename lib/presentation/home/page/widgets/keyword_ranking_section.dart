import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_shimmer.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class KeywordRankingsSection extends StatefulWidget {
  const KeywordRankingsSection({
    super.key,
  });

  @override
  State<KeywordRankingsSection> createState() => _KeywordRankingsSectionState();
}

class _KeywordRankingsSectionState extends State<KeywordRankingsSection>
    with TickerProviderStateMixin {
  final HomeController controller = Get.find();

  bool isExpanded = false;
  int currentRankingIndex = 0;
  Timer? _timer;
  Timer? _shimmerTimer;
  bool _showShimmer = true;
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
    _startShimmerTimer();
  }

  void _startShimmerTimer() {
    _shimmerTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showShimmer = false;
        });
      }
    });
  }

  void _initializeAnimations() {
    // Clear existing controllers first
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();

    if (controller.trendingKeywords.isEmpty) return;

    _controllers = List.generate(
      controller.trendingKeywords.length,
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
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isExpanded && controller.trendingKeywords.isNotEmpty) {
        setState(() {
          currentRankingIndex =
              (currentRankingIndex + 1) % controller.trendingKeywords.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shimmerTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap() {
    if (controller.trendingKeywords.isEmpty) return;

    setState(() {
      isExpanded = !isExpanded;
      if (!isExpanded) {
        _startTimer();
        for (var controller in _controllers) {
          controller.reverse();
        }
      } else {
        _timer?.cancel();
        for (var controller in _controllers) {
          controller.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controllers.length != controller.trendingKeywords.length) {
        _initializeAnimations();
      }

      if (controller.trendingKeywords.isEmpty) {
        if (_showShimmer) {
          return SizedBox(
            height: AppDimens.height(60),
            child: const AppShimmer(
              width: double.infinity,
              height: double.infinity,
            ),
          );
        }
        return const SizedBox.shrink();
      }

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
              height: isExpanded ? AppDimens.height(480) : AppDimens.height(60),
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
    });
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
    if (controller.trendingKeywords.isEmpty) {
      return const SizedBox.shrink();
    }

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
          child: _buildSingleRanking(
              controller.trendingKeywords[currentRankingIndex]),
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
      itemCount: controller.trendingKeywords.length,
      itemBuilder: (context, index) {
        if (index >= _animations.length) return const SizedBox.shrink();

        return ScaleTransition(
          scale: _animations[index],
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(_animations[index]),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.width(16),
                vertical: AppDimens.height(12),
              ),
              child: _buildSingleRanking(controller.trendingKeywords[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleRanking(KeywordRankSnapshot ranking) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '${ranking.currentRank}',
            style: TextStyle(
              color: ranking.currentRank <= 3
                  ? AppColor.yellow400
                  : AppColor.graymodern400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacerH(value: AppDimens.width(12)),
        Expanded(
          child: AppText(
            ranking.keyword,
            style: Theme.of(context)
                .textTheme
                .textSM
                .copyWith(color: AppColor.white),
          ),
        ),
        _buildChangeIndicator(ranking.rankChange),
      ],
    );
  }

  Widget _buildChangeIndicator(int change) {
    if (change == 0) {
      return AppText(
        '-',
        style: Theme.of(context)
            .textTheme
            .textSM
            .copyWith(color: AppColor.graymodern400),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
          color: change > 0 ? Colors.red : Colors.blue,
          size: AppDimens.size(14),
        ),
        AppSpacerH(value: AppDimens.width(4)),
        AppText(
          change.abs().toString(),
          style: TextStyle(
            color: change > 0 ? Colors.red : Colors.blue,
            fontSize: AppDimens.size(12),
          ),
        ),
      ],
    );
  }
}
