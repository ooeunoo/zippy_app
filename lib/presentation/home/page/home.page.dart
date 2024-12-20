import 'package:flutter/material.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';

import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/presentation/home/page/widgets/header_section.dart';
import 'package:zippy/presentation/home/page/widgets/news_section.dart';
import 'package:zippy/presentation/home/page/widgets/keyword_ranking_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWrap(child: HomeHeader()),
      body: const SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: KeywordRankingsSection(),
            ),
            SliverToBoxAdapter(
              child: NewsSection(),
            ),
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
}
