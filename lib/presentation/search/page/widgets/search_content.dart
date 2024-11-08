import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_circle_image.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

class SearchContent extends StatelessWidget {
  final List<Map<String, String>> searchResults;
  final TextEditingController searchController;
  final BuildContext parentContext;

  const SearchContent({
    super.key,
    required this.searchResults,
    required this.searchController,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.width(20)),
      itemCount: searchResults.length,
      separatorBuilder: (context, index) =>
          AppSpacerV(value: AppDimens.height(20)),
      itemBuilder: (context, index) {
        return _buildSearchItem(
          searchResults[index]['image'] ?? '',
          searchResults[index]['title'] ?? '',
          searchResults[index]['published'] ?? '',
        );
      },
    );
  }

  Widget _buildSearchItem(String image, String title, String published) {
    final searchText = searchController.text.toLowerCase();
    final titleLower = title.toLowerCase();

    Widget titleWidget;
    if (searchText.isNotEmpty && titleLower.contains(searchText)) {
      final beforeText = title.substring(0, titleLower.indexOf(searchText));
      final matchText = title.substring(titleLower.indexOf(searchText),
          titleLower.indexOf(searchText) + searchText.length);
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
                  style: Theme.of(parentContext).textTheme.textSM.copyWith(
                        color: Colors.white,
                        fontWeight: AppFontWeight.medium,
                      ),
                ),
                AppText(
                  matchText,
                  maxLines: 2,
                  style: Theme.of(parentContext).textTheme.textSM.copyWith(
                        color: AppColor.blue400,
                        fontWeight: AppFontWeight.medium,
                      ),
                ),
                AppText(
                  afterText,
                  maxLines: 2,
                  style: Theme.of(parentContext).textTheme.textSM.copyWith(
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
        style: Theme.of(parentContext).textTheme.textSM.copyWith(
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
                style: Theme.of(parentContext).textTheme.textXS.copyWith(
                      color: AppColor.gray400,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
