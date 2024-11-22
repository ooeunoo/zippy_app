import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/routes/app_pages.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

class ZippyArticleDrawer extends StatelessWidget {
  final List<Article> articles;
  final Function(int) handleJumpToArticle;
  final Function() handleFetchArticles;

  const ZippyArticleDrawer({
    Key? key,
    required this.articles,
    required this.handleJumpToArticle,
    required this.handleFetchArticles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.graymodern900,
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, index) =>
                    _buildDrawerItem(context, index),
              ),
            ),
            _buildDrawerBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppDimens.height(8)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSvg(
            Assets.logo,
            size: AppDimens.size(50),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, int index) {
    Article article = articles[index];

    if (article.isAd) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(10),
            vertical: AppDimens.height(10),
          ),
          child: ArticleRowItem(
            article: article,
            onHandleClickArticle: () {
              Navigator.of(context).pop();
              handleJumpToArticle(index);
            },
          ),
        ),
        if (index != articles.length - 1) const AppDivider(),
      ],
    );
  }

  Widget _buildDrawerBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(8),
        vertical: AppDimens.height(8),
      ),
      decoration: const BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: Icons.refresh_rounded,
            label: '새로고침',
            onTap: () {
              Navigator.pop(context);
              handleFetchArticles();
            },
          ),
          Container(
            width: 1,
            height: AppDimens.height(24),
            color: AppColor.graymodern800,
          ),
          _buildActionButton(
            context,
            icon: Icons.bookmark_rounded,
            label: '저장목록',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.bookmark);
              // TODO: 북마크 페이지로 이동
            },
          ),
          Container(
            width: 1,
            height: AppDimens.height(24),
            color: AppColor.graymodern800,
          ),
          _buildActionButton(
            context,
            icon: Icons.settings_rounded,
            label: '설정',
            onTap: () {
              Navigator.pop(context);
              notifyPreparing();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius(8)),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.width(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColor.brand600,
              size: AppDimens.size(24),
            ),
            SizedBox(height: AppDimens.height(4)),
            AppText(
              label,
              style: Theme.of(context).textTheme.textSM.copyWith(
                    color: AppColor.graymodern300,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
