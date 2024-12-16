import 'package:zippy/presentation/base/page/base.page.dart';
import 'package:zippy/presentation/base/binding/base.binding.dart';
import 'package:zippy/presentation/board/binding/board.binding.dart';
import 'package:zippy/presentation/board/page/board.page.dart';
import 'package:zippy/presentation/bookmark/binding/bookmark.binding.dart';
import 'package:zippy/presentation/bookmark/page/bookmark.page.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/login/binding/login.binding.dart';
import 'package:zippy/presentation/login/page/login.page.dart';
import 'package:zippy/presentation/setting/binding/setting.binding.dart';
import 'package:zippy/presentation/setting/page/setting.page.dart';
import 'package:zippy/presentation/subscription/binding/subscription.binding.dart';
import 'package:zippy/presentation/subscription/page/subscription.page.dart';
import 'package:zippy/presentation/profile/binding/profile.binding.dart';
import 'package:zippy/presentation/profile/page/profile.page.dart';
import 'package:zippy/presentation/search/binding/search.binding.dart';
import 'package:zippy/presentation/search/page/search.page.dart';

class AppPages {
  static const initial = _Paths.base;

  static final routes = [
    GetPage(
      name: Routes.base,
      page: () => const BasePage(),
      binding: BaseBinding(),
      transition: Transition.noTransition,
      children: [
        GetPage(
          name: Routes.board,
          page: () => const BoardPage(),
          binding: BoardBinding(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: Routes.search,
          page: () => SearchPage(),
          binding: SearchBinding(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: Routes.profile,
          page: () => const ProfilePage(),
          binding: ProfileBinding(),
          transition: Transition.noTransition,
        ),
      ],
    ),
    GetPage(
        name: _Paths.login,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: _Paths.subscription,
        page: () => const SubscriptionPage(),
        transition: Transition.rightToLeft,
        binding: SubscriptionBinding()),
    GetPage(
        name: _Paths.bookmark,
        page: () => const BookmarkPage(),
        transition: Transition.rightToLeft,
        binding: BookmarkBinding()),
    // GetPage(
    //     name: _Paths.setting,
    //     page: () => const SettingPage(),
    //     transition: Transition.rightToLeft,
    //     binding: SettingBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const base = _Paths.base;
  static const board = _Paths.board;
  static const search = _Paths.search;
  static const profile = _Paths.profile;
  static const subscription = _Paths.subscription;
  static const bookmark = _Paths.bookmark;
  // static const setting = _Paths.setting;
}

abstract class _Paths {
  _Paths._();
  static const login = '/login';
  static const base = '/';
  static const board = '/board';
  static const search = '/search';
  static const profile = '/profile';
  static const subscription = '/subscription';
  static const bookmark = '/bookmark';
  // static const setting = '/setting';
}
