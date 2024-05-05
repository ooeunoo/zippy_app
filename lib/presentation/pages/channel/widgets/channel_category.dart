import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/presentation/controllers/channel/channel_controller.dart';

class ChannelCategory extends StatelessWidget {
  final Channel channel;
  final Function(Channel, Category) toggleCategory;

  const ChannelCategory(
      {super.key, required this.channel, required this.toggleCategory});

  @override
  Widget build(BuildContext context) {
    ChannelController controller = Get.find();

    return Scaffold(
        appBar: appBar(context, channel),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppDimens.width(20), vertical: AppDimens.height(10)),
          child: SafeArea(child: categoryList(context, controller, channel)),
        ));
  }

  AppBar appBar(BuildContext context, Channel channel) {
    return AppBar(
      centerTitle: false,
      leading: Container(),
      leadingWidth: AppDimens.width(5),
      title: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: AppColor.white,
            ),
          ),
          AppSpacerH(value: AppDimens.size(5)),
          AppText(
            channel.nameKo,
            style: Theme.of(context).textTheme.textXL.copyWith(
                color: AppColor.gray100, fontWeight: AppFontWeight.medium),
          ),
        ],
      ),
    );
  }

  Widget categoryList(
      BuildContext context, ChannelController controller, Channel channel) {
    if (channel.categories == null) {
      return Container();
    }
    return ListView.builder(
        itemCount: channel.categories!.length,
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            Category category = channel.categories![index];
            bool isSubscribe = controller.isAlreadySubscribeCategory(
                channel.id!, category.id!);

            return ListTile(
              title: AppText(category.name,
                  style: Theme.of(context)
                      .textTheme
                      .textLG
                      .copyWith(color: AppColor.graymodern200)),
              subtitle: category.description != null
                  ? AppText(category.description!,
                      style: Theme.of(context)
                          .textTheme
                          .textXS
                          .copyWith(color: AppColor.graymodern400))
                  : null,
              trailing: Switch(
                value: isSubscribe,
                activeColor: AppColor.brand600,
                inactiveThumbColor: AppColor.graymodern600,
                onChanged: (bool value) async {
                  await toggleCategory(channel, category);
                },
              ),
            );
          });
        });
  }
}
