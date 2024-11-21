import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/presentation/search/page/widgets/article_row_item.dart';

class CustomDrawer extends StatelessWidget {
  final List<Article> articles;
  final Function(int) onJumpToArticle;

  const CustomDrawer({
    Key? key,
    required this.articles,
    required this.onJumpToArticle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: AppColor.graymodern950,
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: _buildArticlesList(context),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.height(16)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.brand600,
              child: Icon(Icons.article, color: Colors.white),
            ),
            SizedBox(width: AppDimens.width(12)),
            Expanded(
              child: AppText(
                '최근 게시물',
                style: Theme.of(context).textTheme.textXL.copyWith(
                      color: AppColor.graymodern100,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: AppColor.graymodern100),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: AppDimens.height(8)),
      itemCount: articles.length,
      separatorBuilder: (context, index) => AppDivider(
        color: AppColor.graymodern900,
      ),
      itemBuilder: (context, index) {
        final article = articles[index];
        if (article.isAd) return SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(16),
            vertical: AppDimens.height(12),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
              Future.delayed(Duration(milliseconds: 300), () {
                onJumpToArticle(index);
              });
            },
            child: ArticleRowItem(
              article: article,
              onHandleClickArticle: () {
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 300), () {
                  onJumpToArticle(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.height(16)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.refresh, color: AppColor.brand600),
              title: AppText(
                '새로 고침',
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern100,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            AppDivider(color: AppColor.graymodern800),
            ListTile(
              leading: Icon(Icons.settings, color: AppColor.brand600),
              title: AppText(
                '설정',
                style: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppColor.graymodern100,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
