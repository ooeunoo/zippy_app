import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/content_type.model.dart';

class ContentTypeSelectorSheet extends StatelessWidget {
  final List<ContentType> contentTypes;
  final ContentType? selectedContentType;
  final Function(ContentType) onHandleSelectedContentType;

  const ContentTypeSelectorSheet({
    super.key,
    required this.contentTypes,
    required this.selectedContentType,
    required this.onHandleSelectedContentType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.height(30),
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.width(16)),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimens.height(12),
                    crossAxisSpacing: AppDimens.width(12),
                    childAspectRatio: 2.5,
                  ),
                  itemCount: contentTypes.length,
                  itemBuilder: (context, index) {
                    final contentType = contentTypes[index];
                    final isSelected = selectedContentType?.id == contentType.id;
                    return GestureDetector(
                      onTap: () {
                        onHandleSelectedContentType(contentType);
                        Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(16),
                          vertical: AppDimens.height(12),
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColor.brand500 : AppColor.gray800,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? AppColor.brand400 : AppColor.gray700,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColor.brand500.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (contentType.emoji != null) ...[
                              AppText(
                                contentType.emoji!,
                                style: Theme.of(context).textTheme.textMD,
                              ),
                              SizedBox(width: AppDimens.width(8)),
                            ],
                            Expanded(
                              child: AppText(
                                contentType.name,
                                align: TextAlign.center,
                                style: Theme.of(context).textTheme.textMD.copyWith(
                                      color: AppColor.white,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
