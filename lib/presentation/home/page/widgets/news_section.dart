// lib/presentation/home/page/widgets/news_section.dart

import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_custom_bottom_sheet.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

enum NewsCategory {
  topNews('🔥 TOP 뉴스'),
  todayPick('👍 오늘의 키워드'),
  weeklyPick('🫡 주간 키워드'),
  monthlyPick('� 월간 키워드'),
  ;

  final String value;

  const NewsCategory(this.value);
}

class NewsItem {
  final String title;
  final String source;
  final String time;
  final Map<String, dynamic> stockInfo;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.source,
    required this.time,
    required this.stockInfo,
    required this.imageUrl,
  });
}

class NewsSection extends StatefulWidget {
  const NewsSection({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  String selectedContentType = '전체';
  NewsCategory selectedCategory = NewsCategory.todayPick;

  final List<String> contentTypes = [
    '전체',
    '국내',
    '해외',
    '암호화폐',
    '부동산',
  ];

  final List<NewsItem> newsItems = [
    NewsItem(
      title: '의견: 최근 엔비디아를 둘러싼 두려움이 과장된 것이라고 생각하는 이유',
      source: 'The Motley Fool',
      time: '4시간 전',
      stockInfo: {'name': '엔비디아', 'change': -0.2},
      imageUrl: 'https://picsum.photos/80/80',
    ),
    NewsItem(
      title: '엔비디아 주가 회복, Fed 금리 공포가 칩메이커를 부양할 수 있는 이유',
      source: 'Barrons',
      time: '4시간 전',
      stockInfo: {'name': '엔비디아', 'change': -0.2},
      imageUrl: 'https://picsum.photos/80/80',
    ),
    NewsItem(
      title: 'SK하이닉스, 인디애나 AI칩 공장에 4억 5,800만달러 보조금 지원 받아',
      source: 'investing.com',
      time: '4시간 전',
      stockInfo: {'name': '엔비디아', 'change': -0.2},
      imageUrl: 'https://picsum.photos/80/80',
    ),
  ];
  void _showContentTypeBottomSheet() {
    openCustomBottomSheet(
      Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNewsHeader(),
        _buildNewsItems(),
      ],
    );
  }

  Widget _buildNewsHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: AppDimens.width(16),
            right: AppDimens.width(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                '추천 뉴스',
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.white,
                    ),
              ),
              GestureDetector(
                onTap: _showContentTypeBottomSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.width(12),
                    vertical: AppDimens.height(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        selectedContentType,
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.white,
                            ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacerV(value: AppDimens.height(12)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            right: AppDimens.width(16),
          ),
          child: Row(
            children: NewsCategory.values.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: EdgeInsets.only(right: AppDimens.width(8)),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.width(12),
                      vertical: AppDimens.height(6),
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColor.brand500 : AppColor.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      category.value,
                      style: Theme.of(context).textTheme.textXS.copyWith(
                            color: AppColor.white,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        return _buildNewsItem(newsItems[index]);
      },
    );
  }

  Widget _buildNewsItem(NewsItem news) {
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
                      news.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${news.source} | ${news.time}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2D30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${news.stockInfo['name']} ${news.stockInfo['change']}%',
                        style: TextStyle(
                          color: news.stockInfo['change'] >= 0
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
                  news.imageUrl,
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
