// lib/presentation/home/page/widgets/news_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/extensions/datetime.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_custom_bottom_sheet.dart';
import 'package:zippy/app/widgets/app_divider.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/enum/article_category_type.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/presentation/home/controller/home.controller.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({
    super.key,
  });

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  final HomeController controller = Get.find();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showContentTypeBottomSheet() {
    openCustomBottomSheet(
      Container(),
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
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              right: AppDimens.width(16),
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: ArticleCategoryType.values.length,
            itemBuilder: (context, index) {
              final category = ArticleCategoryType.values[index];
              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == category;
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? AppDimens.width(16) : AppDimens.width(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectedCategory.value = category;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.width(12),
                        vertical: AppDimens.height(6),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.brand500
                            : AppColor.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        category.value,
                        style: Theme.of(context).textTheme.textXS.copyWith(
                              color: AppColor.white,
                            ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItems() {
    return Obx(() {
      if (controller.selectedContentType.value == null) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 500, // 고정된 높이 지정
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            controller.selectedCategory.value = ArticleCategoryType.values[index];
          },
          itemCount: ArticleCategoryType.values.length,
          itemBuilder: (context, pageIndex) {
            final selectedType = controller.selectedContentType.value;
            final category = ArticleCategoryType.values[pageIndex];
            final articles = controller.articleWithCategory[selectedType]?[category] ?? [];

            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) => _buildNewsItem(articles[index]),
            );
          },
        ),
      );
    });
  }

  Widget _buildNewsItem(Article article) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppColor.white,
                          ),
                    ),
                    AppSpacerV(value: AppDimens.height(8)),
                    AppText(
                      '${article.sourceId} | ${article.published.timeAgo()}',
                      style: Theme.of(context).textTheme.textSM.copyWith(
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
                  child: Image.network(
                    article.images.first.toString(),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          AppDivider(height: AppDimens.height(1)),
        ],
      ),
    );
  }
}
