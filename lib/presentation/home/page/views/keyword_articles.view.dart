import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_shimmer.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KeywordArticlesView extends StatefulWidget {
  final String keyword;
  final List<Article> articles;

  const KeywordArticlesView({
    super.key,
    required this.keyword,
    required this.articles,
  });

  @override
  State<KeywordArticlesView> createState() => _KeywordArticlesViewState();
}

class _KeywordArticlesViewState extends State<KeywordArticlesView>
    with SingleTickerProviderStateMixin {
  final ArticleService articleService = Get.find();
  final HomeController homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWrap(
        child: _buildAppBar(),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.articles.isEmpty
            ? _buildEmptyState()
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.width(16),
                    ),
                    sliver: _buildBody(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.article_outlined,
            size: 64,
            color: AppColor.gray400,
          ),
          AppSpacerV(value: AppDimens.height(16)),
          AppText(
            '검색된 기사가 없습니다',
            style: Theme.of(context).textTheme.textMD.copyWith(
                  color: AppColor.gray600,
                  fontWeight: FontWeight.w600,
                ),
          ),
          AppSpacerV(value: AppDimens.height(8)),
          AppText(
            '다른 키워드로 검색해보세요',
            style: Theme.of(context).textTheme.textSM.copyWith(
                  color: AppColor.gray400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppHeader(
      backgroundColor: AppColor.transparent,
      automaticallyImplyLeading: true,
      title: AppText(
        widget.keyword,
        style: Theme.of(context).textTheme.textMD.copyWith(
              color: AppThemeColors.textHigh(context),
              fontWeight: AppFontWeight.medium,
            ),
      ),
    );
  }

  Widget _buildBody() {
    if (homeController.isKeywordArticlesLoading.value) {
      return SliverFillRemaining(
        child: _buildLoadingShimmer(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0 && widget.articles.isNotEmpty) {
            return _buildFeaturedArticle(widget.articles[0]);
          }

          final actualIndex = index - 1;
          if (actualIndex < widget.articles.length - 1) {
            return _buildArticleCard(
              widget.articles[actualIndex + 1],
            );
          }

          if (homeController.isKeywordArticlesLoading.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.height(16)),
              child: Shimmer.fromColors(
                baseColor: AppColor.gray100,
                highlightColor: AppColor.gray50,
                child: Container(
                  height: AppDimens.height(100),
                  margin: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }

          return null;
        },
        childCount: widget.articles.isEmpty
            ? 0
            : widget.articles.length +
                (homeController.isKeywordArticlesLoading.value ? 1 : 0),
      ),
    );
  }

  Widget _buildFeaturedArticle(Article article) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.height(24)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.graymodern800,
          width: 1,
        ),
      ),
      child: Material(
        color: AppColor.gray900,
        child: GestureDetector(
          onTap: () => articleService.onHandleOpenOriginalArticle(article),
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radius(16)),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildArticleImage(article),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimens.width(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      article.title,
                      style: Theme.of(context).textTheme.textLG.copyWith(
                            color: AppColor.gray50,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacerV(value: AppDimens.height(18)),
                    _buildArticleMetadata(article, isFeatured: true),
                    if (article.excerpt != null) ...[
                      AppSpacerV(value: AppDimens.height(12)),
                      AppText(
                        article.excerpt!,
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.gray400,
                              height: 1.5,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    AppSpacerV(value: AppDimens.height(16)),
                    _buildKeywords(article),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.height(12)),
      decoration: BoxDecoration(
        color: AppColor.graymodern900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.graymodern800,
          width: 1,
        ),
      ),
      child: Material(
        color: AppColor.transparent,
        child: GestureDetector(
          onTap: () => articleService.onHandleOpenOriginalArticle(article),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.all(AppDimens.width(12)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: AppDimens.width(100),
                        height: AppDimens.height(80),
                        child: _buildArticleImage(article),
                      ),
                    ),
                    AppSpacerH(value: AppDimens.width(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            article.title,
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: AppColor.white,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacerV(value: AppDimens.height(12)),
                          _buildArticleMetadata(article),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage(Article article) {
    String? imageUrl =
        article.images.isNotEmpty ? article.images[0].toString() : null;

    if (imageUrl == null) {
      return Container(
        color: AppColor.gray100,
        child: const Center(
          child: Icon(
            Icons.article,
            color: AppColor.gray400,
            size: 32,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColor.gray100,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColor.brand400,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColor.gray100,
        child: const Center(
          child: Icon(
            Icons.error_outline,
            color: AppColor.gray400,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleMetadata(Article article, {bool isFeatured = false}) {
    Source? source = articleService.getSourceById(article.sourceId);

    if (isFeatured) {
      return Row(
        children: [
          AppText(
            '${source?.platform?.name ?? ""} | ',
            style: Theme.of(context).textTheme.textXS.copyWith(
                  color: AppColor.graymodern400,
                ),
          ),
          AppText(
            DateFormat('yyyy.MM.dd HH:mm').format(article.published),
            style: Theme.of(context).textTheme.textXS.copyWith(
                  color: AppColor.graymodern400,
                ),
          ),
        ],
      );
    } else {
      return AppText(
        '${source?.platform?.name ?? ""} | ${article.published.timeAgo()}',
        style: Theme.of(context).textTheme.textXS.copyWith(
              color: AppColor.graymodern400,
            ),
      );
    }
  }

  Widget _buildKeywords(Article article) {
    return Wrap(
      spacing: AppDimens.width(6),
      runSpacing: AppDimens.height(6),
      children:
          article.keywords.where((k) => k != widget.keyword).map((keyword) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(12),
            vertical: AppDimens.height(6),
          ),
          decoration: BoxDecoration(
            color: AppColor.graymodern900,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColor.brand400,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.brand400.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tag,
                size: AppDimens.width(12),
                color: AppColor.brand400,
              ),
              AppSpacerH(value: AppDimens.width(4)),
              AppText(
                keyword,
                style: Theme.of(context).textTheme.textXS.copyWith(
                      color: AppColor.gray50,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppDimens.height(16)),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.gray200.withOpacity(0.5),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.width(16)),
            child: Row(
              children: [
                AppShimmer(
                  width: 88,
                  height: 88,
                  radius: 8,
                ),
                AppSpacerH(value: AppDimens.width(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppShimmer(
                        width: double.infinity,
                        height: AppDimens.height(16),
                        radius: AppDimens.radius(4),
                      ),
                      AppSpacerV(value: AppDimens.height(8)),
                      AppShimmer(
                        width: AppDimens.width(120),
                        height: AppDimens.height(12),
                        radius: AppDimens.radius(4),
                      ),
                      AppSpacerV(value: AppDimens.height(8)),
                      AppShimmer(
                        width: AppDimens.width(80),
                        height: AppDimens.height(12),
                        radius: AppDimens.radius(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
