import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/content_type.service.dart';
import 'package:zippy/app/services/subscription.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/presentation/subscription/page/widget/subscription_card.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final ContentTypeService contentTypeService = Get.find();
  final SubscriptionService subscriptionService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20), vertical: AppDimens.height(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            title(context),
            const AppSpacerV(value: 16),
            Expanded(
              child: subscriptionList(context),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppHeader(
      backgroundColor: AppColor.transparent,
      automaticallyImplyLeading: true,
      title: AppText(
        "나의 채널 관리하기",
        style: Theme.of(context).textTheme.textXL.copyWith(
            color: AppColor.gray100, fontWeight: AppFontWeight.medium),
      ),
    );
  }

  Widget title(BuildContext context) {
    return AppText("보고싶은 채널을 선택해주세요! \n채널에 올라오는 소식을 받아보실 수 있어요 😌",
        style: Theme.of(context)
            .textTheme
            .textMD
            .copyWith(color: AppColor.gray400));
  }

  Widget subscriptionList(BuildContext context) {
    return Obx(
      () => ListView.separated(
        itemCount: contentTypeService.contentTypes.length,
        separatorBuilder: (context, index) =>
            AppSpacerV(value: AppDimens.height(16)),
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            ContentType contentType = contentTypeService.contentTypes[index];
            bool isSubscribe = subscriptionService.userSubscriptions.any(
                (subscription) => subscription.contentTypeId == contentType.id);

            return GestureDetector(
              onTap: () =>
                  subscriptionService.onHandleToggleSubscription(contentType),
              child: SubscriptionCard(
                name: contentType.name,
                description: contentType.description,
                image: contentType.imageUrl,
                isSubscribe: isSubscribe,
              ),
            );
          });
        },
      ),
    );
  }

  Widget notifyReadyChannel(BuildContext context) {
    return Column(
      children: [
        const AppSpacerV(),
        AppText("채널을 준비 중이에요.",
            style: Theme.of(context)
                .textTheme
                .textLG
                .copyWith(color: AppColor.graymodern300)),
        const AppSpacerV(),
      ],
    );
  }
}
