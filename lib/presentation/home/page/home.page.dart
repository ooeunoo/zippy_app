import 'package:flutter/material.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';

import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/presentation/home/page/widgets/section/header_section.dart';
import 'package:zippy/presentation/home/page/widgets/section/news_section.dart';
import 'package:zippy/presentation/home/page/widgets/section/keyword_ranking_section.dart';

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
      appBar: const AppHeaderWrap(child: HomeHeader()),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: AppDimens.height(16)),
              sliver: const SliverToBoxAdapter(
                child: KeywordRankingsSection(),
              ),
            ),
            const NewsSection(),
          ],
        ),
      ),
    );
  }
}
