import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/app/widgets/app_header.dart';
import 'package:zippy/app/widgets/app_loader.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_svg.dart';
import 'package:zippy/app/widgets/app_text.dart';
import 'package:zippy/domain/model/platform.model.dart';
import 'package:zippy/presentation/platform/controller/platform.controller.dart';

class PlatformPage extends StatefulWidget {
  const PlatformPage({super.key});

  @override
  State<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage>
    with SingleTickerProviderStateMixin {
  PlatformController controller = Get.find();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            tabBar(),
            Expanded(
              child: tabBarView(context, controller),
            )
          ],
        ),
      ),
      // floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.symmetric(
      //       horizontal: AppDimens.width(20), vertical: AppDimens.height(30)),
      //   child: ExpandableFab(
      //     distance: AppDimens.height(70),
      //     openButtonBuilder: DefaultFloatingActionButtonBuilder(
      //       child: const Icon(Icons.add),
      //       fabSize: ExpandableFabSize.regular,
      //       backgroundColor: AppColor.brand500,
      //       foregroundColor: AppColor.graymodern100,
      //       shape: const CircleBorder(),
      //     ),
      //     closeButtonBuilder: RotateFloatingActionButtonBuilder(
      //       child: const Icon(Icons.close),
      //       fabSize: ExpandableFabSize.regular,
      //       backgroundColor: AppColor.brand500,
      //       foregroundColor: AppColor.graymodern100,
      //       shape: const CircleBorder(),
      //     ),
      //     type: ExpandableFabType.up,
      //     children: [
      //       AppButton(
      //         "모든 구독 초기화하기",
      //         color: AppColor.brand500,
      //         height: AppDimens.height(50),
      //         titleStyle: Theme.of(context).textTheme.textMD.copyWith(
      //             color: AppColor.graymodern100,
      //             fontWeight: AppFontWeight.regular),
      //         onPressed: () {},
      //       ),
      //       AppButton(
      //         "웃긴 콘텐츠 구독하기",
      //         color: AppColor.brand500,
      //         height: AppDimens.height(50),
      //         titleStyle: Theme.of(context).textTheme.textMD.copyWith(
      //             color: AppColor.graymodern100,
      //             fontWeight: AppFontWeight.regular),
      //         onPressed: () {},
      //       ),
      //       AppButton(
      //         "뉴스 콘텐츠 구독하기",
      //         color: AppColor.brand500,
      //         height: AppDimens.height(50),
      //         titleStyle: Theme.of(context).textTheme.textMD.copyWith(
      //             color: AppColor.graymodern100,
      //             fontWeight: AppFontWeight.regular),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // )
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
    // return AppBar(
    //   centerTitle: false,
    //   leading: Container(),
    //   leadingWidth: AppDimens.width(5),
    //   title: Row(
    //     children: [
    //       GestureDetector(
    //         onTap: Get.back,
    //         child: const Icon(
    //           Icons.chevron_left,
    //           size: 30,
    //           color: AppColor.white,
    //         ),
    //       ),
    //       AppSpacerH(value: AppDimens.size(5)),
    //       AppText(
    //         "나의 채널 관리하기",
    //         style: Theme.of(context).textTheme.textXL.copyWith(
    //             color: AppColor.gray100, fontWeight: AppFontWeight.medium),
    //       ),
    //     ],
    //   ),
    // );
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

  TabBarView tabBarView(BuildContext context, PlatformController controller) {
    return TabBarView(controller: _tabController, children: [
      Obx(() => platformList(context, controller.communities)),
      Obx(() => platformList(context, controller.news)),
      // notifyReadyChannel(context),
    ]);
  }

  Widget platformList(BuildContext context, List<Platform> platforms) {
    if (platforms.isEmpty) {
      return notifyReadyChannel(context);
    }
    return ListView.builder(
      itemCount: platforms.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(() {
          Platform platform = platforms[index];
          bool isSubscribe = controller.userSubscriptions
              .any((subscription) => subscription.platformId == platform.id);

          return ListTile(
            leading: SizedBox(
              height: AppDimens.size(30),
              width: AppDimens.size(30),
              child: platform.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: platform.imageUrl!,
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
              platform.name,
              style: Theme.of(context)
                  .textTheme
                  .textLG
                  .copyWith(color: AppColor.graymodern200),
            ),
            trailing: Switch(
              value: isSubscribe,
              activeColor: AppColor.brand600,
              inactiveThumbColor: AppColor.graymodern600,
              onChanged: (bool value) async {
                await controller.togglePlatform(platform.id!);
              },
            ),
          );
        });
      },
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

  // void _showPopupMenu(BuildContext context) {
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final RenderBox overlay =
  //       Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final Offset position =
  //       button.localToGlobal(Offset.zero, ancestor: overlay);

  //   final RelativeRect positionOffset = RelativeRect.fromRect(
  //     Rect.fromPoints(
  //       position,
  //       position.translate(0, -button.size.height), // 버튼의 위쪽으로 이동
  //     ),
  //     Offset.zero & overlay.size,
  //   );

  //   showMenu(
  //     context: context,
  //     position: positionOffset,
  //     items: <PopupMenuEntry>[
  //       const PopupMenuItem(
  //         child: Text('Item 1'),
  //       ),
  //       const PopupMenuItem(
  //         child: Text('Item 2'),
  //       ),
  //       const PopupMenuItem(
  //         child: Text('Item 3'),
  //       ),
  //     ],
  //   );
  // }
}
