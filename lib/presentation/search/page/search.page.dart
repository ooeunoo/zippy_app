import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
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

  Widget _buildSearchContent() {
    return Container(); // 검색 결과를 표시할 위젯 구현 예정
  }

  Widget _buildRankContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLastUpdateText(),
        AppSpacerV(value: AppDimens.height(20)),
        _buildCategoryTabList(),
        AppSpacerV(value: AppDimens.height(20)),
        _buildSearchRankList(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return _showSearchBar ? _buildSearchAppBar() : _buildDefaultAppBar();
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
            }
          },
        ),
      ],
    );
  }

  AppHeader _buildDefaultAppBar() {
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

  Widget _buildSearchRankList() {
    return Expanded(
      child: ListView(
        children: [
          _buildSearchRankItem(1, '인공지능 챗봇', '새로운 AI 서비스 출시로 화제', '▲ 3'),
          _buildSearchRankItem(2, '메타버스 콘서트', '유명 아이돌 그룹 가상 공연 예정', '▼ 1'),
          _buildSearchRankItem(3, '친환경 에너지', '새로운 정부 정책 발표로 관심 증가', '▲ 5'),
          _buildSearchRankItem(4, '우주 탐사 미션', '민간 기업의 화성 탐사 계획 공개', '▲ 2'),
          _buildSearchRankItem(5, '글로벌 경제 전망', '주요 기관의 2024년 경제 예측 발표', '▼ 2'),
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

  Widget _buildSearchRankItem(
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
          AppSpacerH(value: AppDimens.width(10)),
          _buildSearchItemContent(title, description),
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

  Widget _buildSearchItemContent(String title, String description) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
            fontFamily: 'Arial',
            fontSize: 14,
            color: delta.startsWith('▲') ? AppColor.blue400 : AppColor.rose400,
          ),
    );
  }
}
