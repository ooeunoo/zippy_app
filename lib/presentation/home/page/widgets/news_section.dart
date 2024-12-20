// lib/presentation/home/page/widgets/news_section.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/services/article.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_custom_bottom_sheet.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/enum/article_category_type.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({
    super.key,
  });

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  final ArticleService articleService = Get.find();
  final HomeController controller = Get.find();
  final PageController _pageController = PageController();
  final ScrollController _tabScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _showContentTypeBottomSheet() {
    openCustomBottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.height(30),
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                final contentTypes = controller.contentTypes;
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimens.height(8),
                    crossAxisSpacing: AppDimens.width(8),
                    childAspectRatio: 2.5,
                  ),
                  itemCount: contentTypes.length,
                  itemBuilder: (context, index) {
                    final contentType = contentTypes[index];
                    return GestureDetector(
                      onTap: () {
                        controller.selectedContentType.value = contentType;
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(12),
                          vertical: AppDimens.height(8),
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectedContentType.value?.id ==
                                  contentType.id
                              ? AppColor.brand500
                              : AppColor.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              contentType.name,
                              style:
                                  Theme.of(context).textTheme.textMD.copyWith(
                                        color: AppColor.white,
                                      ),
                            ),
                            AppSpacerV(value: AppDimens.height(2)),
                            AppText(
                              contentType.description,
                              style:
                                  Theme.of(context).textTheme.textXS.copyWith(
                                        color: AppColor.graymodern200,
                                      ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNewsHeader(),
        _buildNewsItems(),
      ],
    );
  }

  Widget _buildNewsHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                      Obx(() => AppText(
                            controller.selectedContentType.value?.name ?? '',
                            style: Theme.of(context).textTheme.textSM.copyWith(
                                  color: AppColor.white,
                                ),
                          )),
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
        SizedBox(
          height: AppDimens.height(36),
          child: ListView.builder(
            controller: _tabScrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: AppDimens.width(12),
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: ArticleCategoryType.values.length,
            itemBuilder: (context, index) {
              final category = ArticleCategoryType.values[index];
              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == category;
                return GestureDetector(
                  onTap: () {
                    controller.selectedCategory.value = category;
                    _pageController.jumpToPage(index);
                    final tabWidth = AppDimens.width(100);
                    final screenWidth = MediaQuery.of(context).size.width;
                    final offset =
                        (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

                    _tabScrollController.animateTo(
                      offset.clamp(
                          0, _tabScrollController.position.maxScrollExtent),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: _buildCategoryTab(category, isSelected),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab(ArticleCategoryType category, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: AppDimens.width(8)),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.width(12),
        vertical: AppDimens.height(6),
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.brand500
            : AppColor.graymodern800.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColor.brand400 : AppColor.transparent,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColor.brand500.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: AppText(
        category.value,
        style: Theme.of(context).textTheme.textXS.copyWith(
              color: isSelected ? AppColor.white : AppColor.graymodern400,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
    );
  }

  Widget _buildNewsItems() {
    return Obx(() {
      if (controller.selectedContentType.value == null) {
        return const SizedBox.shrink();
      }

      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final selectedType = controller.selectedContentType.value;

      // 현재 선택된 카테고리의 기사들을 가져와 전체 높이 계산
      final currentArticles = controller.articleWithCategory[selectedType]
              ?[controller.selectedCategory.value] ??
          [];
      final totalHeight = currentArticles.isEmpty
          ? AppDimens.height(500) // 빈 상태 메시지를 위한 최소 높이
          : currentArticles.length * (AppDimens.height(120));

      return SizedBox(
        height: totalHeight.toDouble(),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            controller.selectedCategory.value =
                ArticleCategoryType.values[index];

            final tabWidth = AppDimens.width(100);
            final screenWidth = MediaQuery.of(context).size.width;
            final offset =
                (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

            _tabScrollController.animateTo(
              offset.clamp(0, _tabScrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          itemCount: ArticleCategoryType.values.length,
          itemBuilder: (context, pageIndex) {
            final category = ArticleCategoryType.values[pageIndex];
            final articles =
                controller.articleWithCategory[selectedType]?[category] ?? [];
            if (articles.isEmpty) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: AppDimens.height(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: AppDimens.height(48),
                      color: AppColor.graymodern300,
                    ),
                    AppSpacerV(value: AppDimens.height(16)),
                    AppText(
                      '가져올 수 있는 기사가 없어요 🥲',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppColor.graymodern400,
                            fontWeight: AppFontWeight.bold,
                          ),
                    ),
                    AppSpacerV(value: AppDimens.height(8)),
                    AppText(
                      '잠시 후 다시 확인해주세요',
                      style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppColor.graymodern300,
                          ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    articles.map((article) => _buildNewsItem(article)).toList(),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildNewsItem(Article article) {
    Source? source = articleService.getSourceById(article.sourceId);

    return GestureDetector(
      onTap: () {
        articleService.onHandleOpenOriginalArticle(article);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppDimens.height(120),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(16),
          vertical: AppDimens.height(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        article.title,
                        style: Theme.of(context).textTheme.textSM.copyWith(
                              color: AppColor.white,
                            ),
                      ),
                      AppSpacerV(value: AppDimens.height(8)),
                      AppText(
                        '${source?.platform?.name ?? ""} | ${article.published.timeAgo()}',
                        style: Theme.of(context).textTheme.textXS.copyWith(
                              color: AppColor.graymodern400,
                            ),
                      ),
                      AppSpacerV(value: AppDimens.height(8)),
                    ],
                  ),
                ),
                AppSpacerH(value: AppDimens.width(16)),
                if (article.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: article.images.first.toString(),
                      width: AppDimens.width(80),
                      height: AppDimens.height(80),
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
