import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/utils/styles/color.dart';
import 'package:zippy/app/utils/styles/dimens.dart';
import 'package:zippy/app/utils/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/community.dart';
import 'package:zippy/presentation/controllers/subscribe_channel/subscribe_channel_controller.dart';

class SubscribeChannel extends StatefulWidget {
  const SubscribeChannel({super.key});

  @override
  State<SubscribeChannel> createState() => _SubscribeChannelState();
}

class _SubscribeChannelState extends State<SubscribeChannel> {
  SubscribeChannelController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.width(20), vertical: AppDimens.height(10)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [title(context), const AppSpacerV(), channel(context)],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Container(),
      leadingWidth: AppDimens.width(5),
      title: AppText("나의 채널 관리하기",
          style: Theme.of(context)
              .textTheme
              .displayXS
              .copyWith(color: AppColor.gray100)),
    );
  }

  Widget title(BuildContext context) {
    return AppText("보고싶은 채널을 선택해주세요! \n채널에 올라오는 소식을 받아보실 수 있어요 😌",
        style: Theme.of(context)
            .textTheme
            .textMD
            .copyWith(color: AppColor.gray400));
  }

  Widget channel(BuildContext context) {
    return Expanded(
      child: Obx(() => ListView.builder(
            itemCount: controller.communities.length,
            itemBuilder: (BuildContext context, int index) {
              Community community = controller.communities[index];
              return ListTile(
                leading: SizedBox(
                  height: AppDimens.size(30),
                  width: AppDimens.size(30),
                  child: CircleAvatar(
                    radius: AppDimens.size(16),
                    backgroundImage:
                        AssetImage(community.getLogoAssetPath() ?? ""),
                  ),
                ),
                title: AppText(community.nameKo,
                    style: Theme.of(context)
                        .textTheme
                        .textLG
                        .copyWith(color: AppColor.graymodern200)),
                trailing: Switch(
                  value: false,
                  onChanged: (bool value) {
                    // 스위치가 토글될 때의 동작
                  },
                ),
              );
            },
          )),
    );
  }
}
