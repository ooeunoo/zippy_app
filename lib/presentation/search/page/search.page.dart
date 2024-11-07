import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

enum SearchCategory {
  all('전체'),
  news('뉴스'),
  entertainment('엔터'),
  sports('스포츠'),
  economy('경제'),
  life('생활');

  final String label;
  const SearchCategory(this.label);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  SearchCategory _selectedCategory = SearchCategory.all;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: SearchCategory.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = SearchCategory.values[_tabController.index];
        });
      }
    });
  }

  // Mock data for search results
  final List<Map<String, String>> _searchResults = [
    {
      'image': "https://img.sbs.co.kr/newimg/news/20240822/201976009_1280.jpg",
      'title':
          '새로운 AI 기술 발전, 일상생활 변화 예고로운 AI 기술 발전, 일상생활 변화 예고로운 AI 기술 발전, 일상생활 변화 예고',
      'published': '2024.01.15 14:30',
    },
    {
      'image': "https://img.sbs.co.kr/newimg/news/20240822/201976009_1280.jpg",
      'title': '글로벌 기업들의 메타버스 투자 확대',
      'published': '2024.01.15 13:45',
    },
    {
      'image': "https://img.sbs.co.kr/newimg/news/20240822/201976009_1280.jpg",
      'title': '친환경 에너지 정책 새로운 전환점 맞이해',
      'published': '2024.01.15 12:20',
    },
    {
      'image': "https://img.sbs.co.kr/newimg/news/20240822/201976009_1280.jpg",
      'title': '우주 탐사 새로운 발견, 과학계 흥분',
      'published': '2024.01.15 11:15',
    },
    {
      'image': "https://img.sbs.co.kr/newimg/news/20240822/201976009_1280.jpg",
      'title': '2024년 경제 전망, 전문가들의 분석',
      'published': '2024.01.15 10:30',
    },
  ];

  // Mock data for each category
  final Map<SearchCategory, List<Map<String, String>>> _categoryRankItems = {
    SearchCategory.all: [
      {'title': '인공지능 챗봇', 'description': '새로운 AI 서비스 출시로 화제', 'delta': '▲ 3'},
      {
        'title': '메타버스 콘서트',
        'description': '유명 아이돌 그룹 가상 공연 예정',
        'delta': '▼ 1'
      },
      {
        'title': '친환경 에너지',
        'description': '새로운 정부 정책 발표로 관심 증가',
        'delta': '▲ 5'
      },
      {
        'title': '우주 탐사 미션',
        'description': '민간 기업의 화성 탐사 계획 공개',
        'delta': '▲ 2'
      },
      {
        'title': '글로벌 경제 전망',
        'description': '주요 기관의 2024년 경제 예측 발표',
        'delta': '▼ 2'
      },
    ],
    SearchCategory.news: [
      {'title': '국제 정상회담', 'description': '주요국 정상들 기후변화 대책 논의', 'delta': '▲ 4'},
      {
        'title': '코로나19 신규 변이',
        'description': '전문가들 경계태세 강화 촉구',
        'delta': '▲ 2'
      },
      {'title': '반도체 산업 전망', 'description': '글로벌 공급망 재편 움직임', 'delta': '▼ 1'},
    ],
    SearchCategory.entertainment: [
      {'title': '신예 걸그룹 데뷔', 'description': '화려한 퍼포먼스로 주목받아', 'delta': '▲ 7'},
      {'title': '인기 드라마 시즌2', 'description': '내년 초 제작 확정', 'delta': '▲ 3'},
      {'title': '유명 배우 결혼', 'description': '5년 열애 끝 결실', 'delta': '▼ 2'},
    ],
    SearchCategory.sports: [
      {'title': '월드컵 예선', 'description': '한국 대표팀 중요한 승리', 'delta': '▲ 5'},
      {'title': 'NBA 스타 이적설', 'description': '새로운 팀과 협상 중', 'delta': '▲ 1'},
      {'title': '올림픽 메달 전망', 'description': '기대종목 분석', 'delta': '▼ 3'},
    ],
    SearchCategory.economy: [
      {'title': '금리 인상 전망', 'description': '중앙은행 정책 변화 예고', 'delta': '▲ 6'},
      {'title': '주식시장 신기록', 'description': '코스피 사상 최고치 경신', 'delta': '▲ 2'},
      {'title': '부동산 시장 동향', 'description': '규제 완화 효과 분석', 'delta': '▼ 1'},
    ],
    SearchCategory.life: [
      {
        'title': '겨울 건강관리법',
        'description': '전문의가 추천하는 면역력 강화 팁',
        'delta': '▲ 4'
      },
      {'title': '실내 운동 트렌드', 'description': '홈트레이닝 인기 지속', 'delta': '▲ 2'},
      {'title': '식품 물가 동향', 'description': '장바구니 물가 비교', 'delta': '▼ 3'},
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _showSearchBar ? _buildSearchContent() : _buildRankContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return _showSearchBar ? _buildSearchAppBar() : _buildRankAppBar();
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.gray100),
        onPressed: () {
          setState(() {
            _showSearchBar = false;
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        style: Theme.of(context)
            .textTheme
            .textSM
            .copyWith(color: AppColor.gray100),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          hintStyle: Theme.of(context)
              .textTheme
              .textSM
              .copyWith(color: AppColor.gray400),
          border: InputBorder.none,
        ),
        autofocus: true,
        onChanged: (value) {
          setState(() {}); // Trigger rebuild when search text changes
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear, color: AppColor.gray100),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                _showSearchBar = false;
              });
            } else {
              _searchController.clear();
              setState(() {}); // Trigger rebuild when cleared
            }
          },
        ),
      ],
    );
  }

  AppHeader _buildRankAppBar() {
    return AppHeader(
      title: AppText(
        '실시간 검색 순위',
        style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.gray100, fontWeight: AppFontWeight.medium),
      ),
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showSearchBar = true;
            });
          },
          icon: const Icon(Icons.search, color: AppColor.gray100),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) =>
          AppSpacerV(value: AppDimens.height(20)),
      itemBuilder: (context, index) {
        return _buildSearchItem(
          _searchResults[index]['image'] ?? '',
          _searchResults[index]['title'] ?? '',
          _searchResults[index]['published'] ?? '',
        );
      },
    );
  }

  Widget _buildRankContent() {
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

  Widget _buildSearchItem(String image, String title, String published) {
    final searchText = _searchController.text.toLowerCase();
    final titleLower = title.toLowerCase();

    Widget titleWidget;
    if (searchText.isNotEmpty && titleLower.contains(searchText)) {
      final beforeText = title.substring(0, titleLower.indexOf(searchText));
      final matchText = title.substring(titleLower.indexOf(searchText),
          titleLower.indexOf(searchText) + searchText.length);
      final afterText =
          title.substring(titleLower.indexOf(searchText) + searchText.length);

      titleWidget = Row(
        children: [
          Expanded(
            child: Wrap(
              children: [
                AppText(
                  beforeText,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                        color: Colors.white,
                        fontWeight: AppFontWeight.medium,
                      ),
                ),
                AppText(
                  matchText,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                        color: AppColor.blue400,
                        fontWeight: AppFontWeight.medium,
                      ),
                ),
                AppText(
                  afterText,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.textSM.copyWith(
                        color: Colors.white,
                        fontWeight: AppFontWeight.medium,
                      ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      titleWidget = AppText(
        title,
        maxLines: 2,
        style: Theme.of(context).textTheme.textSM.copyWith(
              color: Colors.white,
              fontWeight: AppFontWeight.medium,
            ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppDimens.height(2)),
          child: AppCircleImage(image),
        ),
        AppSpacerH(value: AppDimens.width(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              AppSpacerV(value: AppDimens.height(8)),
              AppText(
                published,
                style: Theme.of(context).textTheme.textXS.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdateText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      child: AppText(
        '5분 전 업데이트',
        style: Theme.of(context).textTheme.textXS.copyWith(
              color: AppColor.gray400,
            ),
      ),
    );
  }

  Widget _buildCategoryTabList() {
    return TabBar(
      padding: EdgeInsets.zero,
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      labelPadding: EdgeInsets.only(
        right: AppDimens.width(10),
      ),
      tabs: SearchCategory.values.map((category) {
        return Tab(
          iconMargin: EdgeInsets.zero,
          child: _buildCategoryTab(
            category.label,
            isActive: _selectedCategory == category,
            onTap: () {
              setState(() => _selectedCategory = category);
              _tabController.animateTo(SearchCategory.values.indexOf(category));
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRankList() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: SearchCategory.values.map((category) {
          final items = _categoryRankItems[category] ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildRankItem(
                index + 1,
                item['title'] ?? '',
                item['description'] ?? '',
                item['delta'] ?? '',
              );
            },
          );
        }).toList(),
      ),
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
              style: Theme.of(context).textTheme.textXS.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankItem(
      int rank, String title, String description, String delta) {
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
          _buildRankItemContent(title, description),
          _buildDeltaIndicator(delta),
        ],
      ),
    );
  }

  Widget _buildRankNumber(int rank) {
    return AppText(
      '$rank',
      style: Theme.of(context).textTheme.textXL.copyWith(
            color: rank == 1
                ? AppColor.orange400
                : rank == 2
                    ? AppColor.yellow400
                    : AppColor.gray500,
          ),
    );
  }

  Widget _buildRankItemContent(String title, String description) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: Colors.white,
                ),
          ),
          AppSpacerV(value: AppDimens.height(5)),
          AppText(
            description,
            style: Theme.of(context).textTheme.textXS.copyWith(
                  color: AppColor.gray400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeltaIndicator(String delta) {
    return AppText(
      delta,
      style: Theme.of(context).textTheme.textXS.copyWith(
            fontSize: 14,
            color: delta.startsWith('▲') ? AppColor.blue400 : AppColor.rose400,
          ),
    );
  }
}
