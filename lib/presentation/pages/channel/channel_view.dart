import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_loader.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:zippy/presentation/controllers/channel/channel_controller.dart';

class ChannelView extends StatefulWidget {
  const ChannelView({super.key});

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView>
    with SingleTickerProviderStateMixin {
  ChannelController controller = Get.find();
  late TabController _tabController;

  final _tabs = [
    const Tab(text: '커뮤니티'),
    const Tab(text: '뉴스'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            children: [
              // title(context),
              // const AppSpacerV(),
              tabBar(),
              Expanded(
                child: tabBarView(context, controller),
              )
            ],
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
            "나의 채널 관리하기",
            style: Theme.of(context).textTheme.textXL.copyWith(
                color: AppColor.gray100, fontWeight: AppFontWeight.medium),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
          child:
              const AppSvg(Assets.dotsVertical, color: AppColor.graymodern100),
        )
      ],
    );
  }

  Widget title(BuildContext context) {
    return AppText("보고싶은 채널을 선택해주세요! \n채널에 올라오는 소식을 받아보실 수 있어요 😌",
        style: Theme.of(context)
            .textTheme
            .textMD
            .copyWith(color: AppColor.gray400));
  }

  TabBar tabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      splashFactory: NoSplash.splashFactory,
      tabAlignment: TabAlignment.start,
      dividerColor: AppColor.graymodern950,
      indicatorColor: Colors.transparent,
      labelPadding: const EdgeInsets.only(left: 0, right: 0),
      labelColor: AppColor.brand600,
      labelStyle: Theme.of(context)
          .textTheme
          .textMD
          .copyWith(fontWeight: AppFontWeight.bold),
      unselectedLabelColor: AppColor.graymodern500,
      tabs: _tabs
          .map((tab) => Padding(
              padding: EdgeInsets.only(right: AppDimens.width(20)),
              child: Tab(text: tab.text)))
          .toList(),
    );
  }

  TabBarView tabBarView(BuildContext context, ChannelController controller) {
    return TabBarView(controller: _tabController, children: [
      Obx(() => channelList(context, controller.communities)),
      Obx(() => channelList(context, controller.news)),
    ]);
  }

  Widget channelList(BuildContext context, List<Channel> channels) {
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(() {
          Channel channel = channels[index];
          List<UserCategory>? subscribeCategoryInChannel =
              controller.userSubscribeCategories.value[channel.id!];

          int total = channel.categories!.length;
          int my = subscribeCategoryInChannel == null
              ? 0
              : subscribeCategoryInChannel.length;

          return GestureDetector(
            onTap: () => controller.onClickChannel(channel),
            child: ListTile(
              leading: SizedBox(
                height: AppDimens.size(30),
                width: AppDimens.size(30),
                child: channel.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: channel.imageUrl!,
                        placeholder: (context, url) => const AppLoader(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                        ),
                      )
                    : const AppSvg(
                        Assets.logo,
                        color: AppColor.gray600,
                      ),
              ),
              title: AppText(
                channel.nameKo,
                style: Theme.of(context)
                    .textTheme
                    .textLG
                    .copyWith(color: AppColor.graymodern200),
              ),
              trailing: AppText('$my/$total',
                  style: Theme.of(context)
                      .textTheme
                      .textSM
                      .copyWith(color: AppColor.graymodern500)),
            ),
          );
        });
      },
    );
  }

  // Widget channel(BuildContext context) {
  //   return Expanded(
  //     child: Obx(() => ListView.builder(
  //           itemCount: controller.channels.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Obx(() {
  //               Channel channel = controller.channels[index];
  //               bool isSubscribe = controller.userSubscribeCategories
  //                   .any((category) => category.channelId == channel.id);

  //               return ListTile(
  //                 leading: SizedBox(
  //                   height: AppDimens.size(30),
  //                   width: AppDimens.size(30),
  //                   child: channel.imageUrl != null
  //                       ? CachedNetworkImage(
  //                           imageUrl: channel.imageUrl!,
  //                           placeholder: (context, url) => const AppLoader(),
  //                           errorWidget: (context, url, error) =>
  //                               const Icon(Icons.error),
  //                           imageBuilder: (context, imageProvider) =>
  //                               CircleAvatar(
  //                             backgroundImage: imageProvider,
  //                             backgroundColor: Colors.transparent,
  //                             foregroundColor: Colors
  //                                 .black, // Change to your desired foreground color
  //                           ),
  //                         )
  //                       : const AppSvg(
  //                           Assets.logo,
  //                           color: AppColor.gray600,
  //                         ),
  //                 ),
  //                 title: AppText(channel.nameKo,
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .textLG
  //                         .copyWith(color: AppColor.graymodern200)),
  //                 trailing: Switch(
  //                   value: isSubscribe,
  //                   activeColor: AppColor.brand600,
  //                   inactiveThumbColor: AppColor.graymodern600,
  //                   onChanged: (bool value) async {
  //                     await controller.toggleChannel(channel.id!);
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //         )),
  //   );
  // }
}
