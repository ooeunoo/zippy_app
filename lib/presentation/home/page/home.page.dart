import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'dart:async';

import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isExpanded = false;
  int currentRankingIndex = 0;
  late Timer _timer;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<Map<String, dynamic>> rankings = [
    {'rank': 1, 'keyword': '삼성전자', 'change': 2},
    {'rank': 2, 'keyword': '애플', 'change': -1},
    {'rank': 3, 'keyword': 'LG에너지솔루션', 'change': 0},
    {'rank': 4, 'keyword': 'SK하이닉스', 'change': 3},
    {'rank': 5, 'keyword': '현대차', 'change': -2},
    {'rank': 6, 'keyword': '카카오', 'change': 1},
    {'rank': 7, 'keyword': '네이버', 'change': -1},
    {'rank': 8, 'keyword': '기아', 'change': 4},
    {'rank': 9, 'keyword': 'LG전자', 'change': -2},
    {'rank': 10, 'keyword': '포스코', 'change': 0},
  ];

  final List<Map<String, dynamic>> newsItems = [
    {
      'title': '의견: 최근 엔비디아를 둘러싼 두려움이 과장된 것이라고 생각하는 이유',
      'source': 'The Motley Fool',
      'time': '4시간 전',
      'stockInfo': {'name': '엔비디아', 'change': -0.2},
      'imageUrl': 'https://picsum.photos/80/80',
    },
    {
      'title': '엔비디아 주가 회복, Fed 금리 공포가 칩메이커를 부양할 수 있는 이유',
      'source': 'Barrons',
      'time': '4시간 전',
      'stockInfo': {'name': '엔비디아', 'change': -0.2},
      'imageUrl': 'https://picsum.photos/80/80',
    },
    {
      'title': 'SK하이닉스, 인디애나 AI칩 공장에 4억 5,800만달러 보조금 지원 받아',
      'source': 'investing.com',
      'time': '4시간 전',
      'stockInfo': {'name': '엔비디아', 'change': -0.2},
      'imageUrl': 'https://picsum.photos/80/80',
    }
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

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWrap(child: _buildHeader()),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildKeywordRankings(),
            _buildNewsItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppHeader(
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
        child: AppSvg(Assets.logo, size: AppDimens.width(60)),
      ),
    );
  }

  Widget _buildKeywordRankings() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
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
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 480 : 60, // 높이를 480으로 증가
            child: Column(
              children: [
                _buildRankingHeader(),
                if (isExpanded) Expanded(child: _buildRankingList()),
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
      child: Row(
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
                      .textXS
                      .copyWith(color: AppColor.white),
                ),
              ],
            ),
          ),
          AppSpacerH(value: AppDimens.width(12)),
          Expanded(
            child: !isExpanded
                ? _buildSingleRanking(rankings[currentRankingIndex])
                : const SizedBox(),
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
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

  Widget _buildSingleRanking(Map<String, dynamic> ranking) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '${ranking['rank']}',
            style: TextStyle(
              color: ranking['rank'] <= 3 ? Colors.amber : Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            ranking['keyword'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        _buildChangeIndicator(ranking['change']),
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

  Widget _buildNewsItems() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: newsItems.length,
        (context, index) {
          return _buildNewsItem(newsItems[index]);
        },
      ),
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> news) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${news['source']} | ${news['time']}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2D30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${news['stockInfo']['name']} ${news['stockInfo']['change']}%',
                        style: TextStyle(
                          color: news['stockInfo']['change'] >= 0
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  news['imageUrl'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF2C2D30), height: 32),
        ],
      ),
    );
  }
}
