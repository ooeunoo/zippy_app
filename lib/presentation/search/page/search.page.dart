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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
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
      // 검색어가 있는 경우 검색어 앞부분 텍스트
      final beforeText = title.substring(0, titleLower.indexOf(searchText));

      // 검색어와 일치하는 부분 텍스트
      final matchText = title.substring(titleLower.indexOf(searchText),
          titleLower.indexOf(searchText) + searchText.length);

      // 검색어 뒷부분 텍스트
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryTab('전체', isActive: true),
            AppSpacerH(value: AppDimens.width(10)),
            _buildCategoryTab('뉴스'),
            AppSpacerH(value: AppDimens.width(10)),
            _buildCategoryTab('엔터'),
            AppSpacerH(value: AppDimens.width(10)),
            _buildCategoryTab('스포츠'),
            AppSpacerH(value: AppDimens.width(10)),
            _buildCategoryTab('경제'),
            AppSpacerH(value: AppDimens.width(10)),
            _buildCategoryTab('생활'),
          ],
        ),
      ),
    );
  }

  Widget _buildRankList() {
    return Expanded(
      child: ListView(
        children: [
          _buildRankItem(1, '인공지능 챗봇', '새로운 AI 서비스 출시로 화제', '▲ 3'),
          _buildRankItem(2, '메타버스 콘서트', '유명 아이돌 그룹 가상 공연 예정', '▼ 1'),
          _buildRankItem(3, '친환경 에너지', '새로운 정부 정책 발표로 관심 증가', '▲ 5'),
          _buildRankItem(4, '우주 탐사 미션', '민간 기업의 화성 탐사 계획 공개', '▲ 2'),
          _buildRankItem(5, '글로벌 경제 전망', '주요 기관의 2024년 경제 예측 발표', '▼ 2'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String text, {bool isActive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppColor.blue400 : AppColor.graymodern800,
        borderRadius: BorderRadius.circular(AppDimens.radius(16)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(12), vertical: AppDimens.height(4)),
        child: Center(
          child: AppText(
            text,
            style: Theme.of(context).textTheme.textXS.copyWith(
                  color: Colors.white,
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
