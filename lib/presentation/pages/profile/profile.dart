import 'package:cocomu/app/utils/assets.dart';
import 'package:cocomu/app/utils/styles/color.dart';
import 'package:cocomu/app/utils/styles/dimens.dart';
import 'package:cocomu/app/utils/styles/theme.dart';
import 'package:cocomu/app/widgets/app_menu.dart';
import 'package:cocomu/app/widgets/app_spacer_v.dart';
import 'package:cocomu/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // appBar: appBar(context),
            body: Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.width(20), vertical: AppDimens.height(20)),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [avatarInfo(context), const AppSpacerV(), menu(context)],
          ),
          Align(alignment: Alignment.bottomCenter, child: logout(context))
        ],
      ),
    )));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: AppText("프로필",
          style: Theme.of(context)
              .textTheme
              .displaySM
              .copyWith(color: AppColor.graymodern100)),
      centerTitle: false,
    );
  }

  Widget logout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.height(10)),
      child: AppText(
        "로그아웃",
        style: Theme.of(context).textTheme.textSM.copyWith(
              decoration: TextDecoration.underline,
              color: AppColor.graymodern500,
              decorationColor: AppColor.graymodern500,
            ),
      ),
    );
  }

  Widget avatarInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppDimens.size(50),
              width: AppDimens.size(50),
              child: CircleAvatar(
                radius: AppDimens.size(16),
                // backgroundImage: const AssetImage(Assets.avatarDefault),
              ),
            )
          ],
        ),
        const AppSpacerV(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText("seongenugne.adsfdsf@gam",
                style: Theme.of(context)
                    .textTheme
                    .textMD
                    .copyWith(color: AppColor.graymodern100))
          ],
        )
      ],
    );
  }

  Widget menu(BuildContext context) {
    return AppMenu(menu: [
      {
        'section': 'My',
        'items': [
          {
            'icon': Assets.sliders04,
            'title': "구독 채널 관리",
            'onTap': () {
              print('hello');
            }
          },
          {
            'icon': Assets.bookmarkLine,
            'title': "저장한 콘텐츠",
            'onTap': () {
              print('hello');
            }
          }
        ]
      },
      {
        'section': '고객지원 및 정보',
        'items': [
          {
            'icon': Assets.file02,
            'title': "개인정보처리방침",
            'onTap': () {
              print('hello');
            }
          },
          {
            'icon': Assets.file06,
            'title': "서비스 이용약관",
            'onTap': () {
              print('hello');
            }
          }
        ]
      }
    ], backgroundColor: AppColor.gray100);
  }
}
