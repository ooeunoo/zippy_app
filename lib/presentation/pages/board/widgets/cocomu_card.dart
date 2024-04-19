import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';
import 'package:cocomu/app/utils/styles/theme.dart';
import 'package:cocomu/app/widgets/app_spacer_h.dart';
import 'package:cocomu/app/widgets/app_spacer_v.dart';
import 'package:cocomu/app/widgets/app_text.dart';
import 'package:cocomu/domain/model/community.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CocomuCard extends StatelessWidget {
  final Community community;
  final Item item;

  // final String category;
  // final String title;
  // final String content;
  // final String contentImgUrl;

  const CocomuCard({
    super.key,
    required this.community,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(10), vertical: AppDimens.height(20)),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.size(16)),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.black,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.size(16)),
            ),
            shadowColor: const Color.fromRGBO(0, 0, 0, 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Community (1/6 of screen)
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(10),
                          vertical: AppDimens.height(10)),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(community.logo!),
                                ),
                              ),
                              AppSpacerH(value: AppDimens.width(10)),
                              Expanded(
                                child: AppText(
                                  community.nameKo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .textLG
                                      .copyWith(color: AppColor.gray50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Image (3/6 of screen)
                Expanded(
                  flex: 4,
                  child: Container(
                    child: FutureBuilder<void>(
                      future: precacheImage(
                          NetworkImage(item.contentImgUrl), context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading image'));
                        } else {
                          return CachedNetworkImage(
                            imageUrl: item.contentImgUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                // Next Section (1/6 of screen)
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.width(10),
                          vertical: AppDimens.height(10)),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppText(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .textXL
                                        .copyWith(color: AppColor.gray50),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
                // Next Section (1/6 of screen)
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Center(
                      child: Text(
                        item.contentText,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
