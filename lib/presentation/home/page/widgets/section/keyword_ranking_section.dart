import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/app/widgets/app_shimmer.dart';
import 'package:zippy/domain/model/keyword_rank_snaoshot.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';
import 'package:zippy/presentation/home/page/views/search.dart';

class KeywordRankingsSection extends StatefulWidget {
  const KeywordRankingsSection({
    super.key,
  });

  @override
  State<KeywordRankingsSection> createState() => _KeywordRankingsSectionState();
}

class _KeywordRankingsSectionState extends State<KeywordRankingsSection>
    with TickerProviderStateMixin {
  final ArticleService articleService = Get.find();
  final HomeController controller = Get.find();

  bool isExpanded = false;
  int currentRankingIndex = 0;
  Timer? _timer;
  Timer? _shimmerTimer;
  bool _showShimmer = true;
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  bool _isRefreshing = false;
  DateTime? _lastRefreshTime;

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
        duration: Duration(milliseconds: 800 + (index * 50)),
        vsync: this,
      )..reset(), // 생성 시 초기화
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      );
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

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    await controller.onHandleFetchTrendingKeywords();
    _lastRefreshTime = DateTime.now();

    setState(() {
      _isRefreshing = false;
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
          controller.reset(); // 애니메이션 상태 리셋
          controller.reverse();
        }
      } else {
        _timer?.cancel();
        for (var controller in _controllers) {
          controller.reset(); // 애니메이션 상태 리셋
          controller.forward();
        }
      }
    });
  }

  String _getTimeText() {
    if (_lastRefreshTime != null) {
      return _lastRefreshTime!.timeOnly();
    }

    final snapshotTime = DateTime.now();
    final minutes = snapshotTime.minute;
    final roundedMinutes = minutes >= 30 ? 30 : 0;
    return DateTime(
      snapshotTime.year,
      snapshotTime.month,
      snapshotTime.day,
      snapshotTime.hour,
      roundedMinutes,
    ).timeOnly();
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
        color: isExpanded
            ? AppColor.graymodern950.withOpacity(0.5)
            : Colors.transparent,
        child: GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? AppDimens.height(500) : AppDimens.height(60),
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
        Image.asset(
          Assets.trend,
          width: AppDimens.width(18),
          height: AppDimens.height(18),
        ),
        AppSpacerH(value: AppDimens.width(20)),
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
        Row(
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
                  '오늘 ${_getTimeText()} 기준',
                  style: Theme.of(context)
                      .textTheme
                      .textXS
                      .copyWith(color: AppColor.graymodern400),
                ),
              ],
            ),
            IconButton(
              onPressed: _handleRefresh,
              icon: AnimatedRotation(
                duration: const Duration(milliseconds: 3000),
                turns: _isRefreshing ? 2 : 0,
                child: Icon(
                  Icons.refresh,
                  color: _isRefreshing ? AppColor.yellow400 : Colors.white,
                  size: AppDimens.size(20),
                ),
              ),
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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.trendingKeywords.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.trendingKeywords.length) {
          return Column(
            children: [
              AppDivider(height: AppDimens.height(2)),
              AppSpacerV(value: AppDimens.height(30)),
            ],
          );
        }

        if (index >= _animations.length) return const SizedBox.shrink();

        // 각 아이템마다 살짝 다른 딜레이를 줘서 cascade 효과 생성
        final delay = index * 50;
        _controllers[index].duration = Duration(milliseconds: 800 + delay);

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                (1 - _animations[index].value) * 20, // 위에서 아래로 살짝 내려오는 효과
              ),
              child: Opacity(
                opacity: _animations[index].value,
                child: Transform.scale(
                  scale: 0.8 + (_animations[index].value * 0.2), // 살짝 커지는 효과
                  child: child,
                ),
              ),
            );
          },
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _controllers[index],
              curve: Curves.easeOutCubic, // 부드러운 감속 커브
            )),
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

  Widget _buildSingleRanking(
    KeywordRankSnapshot ranking,
  ) {
    return GestureDetector(
      // onTap: () => controller.onHandleGoToSearchView(ranking.keyword),
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.width(24),
            child: AppText(
              '${ranking.currentRank}',
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: ranking.currentRank <= 3
                        ? AppColor.yellow400
                        : AppColor.graymodern400,
                    fontWeight: AppFontWeight.bold,
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
          if (!isExpanded) AppSpacerH(value: AppDimens.width(12)),
        ],
      ),
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
