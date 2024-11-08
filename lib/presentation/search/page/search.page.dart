import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';
import 'package:zippy/presentation/search/page/widgets/rank_content.dart';
import 'package:zippy/presentation/search/page/widgets/search_content.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final AppSearchController controller = Get.find();
  final ContentTypeService contentTypeService = Get.find();
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  RxInt selectedContentTypeId = 0.obs; // 0은 전체를 의미

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: contentTypeService.contentTypes.length + 1,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // index가 0이면 전체(null), 그 외에는 해당 contentType
        final selectedContentType = _tabController.index == 0
            ? null
            : contentTypeService.contentTypes[_tabController.index - 1];
        controller.onHandleTrendingKeywords(selectedContentType);
        selectedContentTypeId.value = selectedContentType?.id ?? 0;
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
        child: _showSearchBar
            ? SearchContent(
                searchResults: _searchResults,
                searchController: _searchController,
                parentContext: context,
              )
            : Obx(() => RankContent(
                  tabController: _tabController,
                  selectedContentTypeId: selectedContentTypeId.value,
                  contentTypes: contentTypeService.contentTypes,
                  trendingKeywords: controller.trendingKeywordsByContentType,
                  parentContext: context,
                )),
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
}
