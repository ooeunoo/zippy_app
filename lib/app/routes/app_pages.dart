import 'package:zippy/presentation/base/page/base.page.dart';
import 'package:zippy/presentation/base/binding/base.binding.dart';
import 'package:zippy/presentation/board/binding/board.binding.dart';
import 'package:zippy/presentation/board/page/board.page.dart';
import 'package:zippy/presentation/bookmark/binding/bookmark.binding.dart';
import 'package:zippy/presentation/bookmark/page/bookmark.page.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/login/bindings/login.binding.dart';
import 'package:zippy/presentation/login/page/login.page.dart';
import 'package:zippy/presentation/platform/bindings/platform.binding.dart';
import 'package:zippy/presentation/platform/page/platform.page.dart';
import 'package:zippy/presentation/profile/bindings/profile.binding.dart';
import 'package:zippy/presentation/profile/page/profile.page.dart';

class AppPages {
  static const initial = _Paths.base;

  static final routes = [
    GetPage(
      name: Routes.base,
      page: () => const BasePage(),
      binding: BaseBinding(),
      children: [
        GetPage(
          name: Routes.board,
          page: () => const BoardPage(),
          binding: BoardBinding(),
        ),
        GetPage(
          name: Routes.profile,
          page: () => const ProfilePage(),
          binding: ProfileBinding(),
        ),
      ],
    ),
    GetPage(
        name: _Paths.login,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: _Paths.platform,
        page: () => const PlatformPage(),
        transition: Transition.rightToLeft,
        binding: PlatformBinding()),
    GetPage(
        name: _Paths.bookmark,
        page: () => const BookmarkPage(),
        transition: Transition.rightToLeft,
        binding: BookmarkBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const base = _Paths.base;
  static const board = _Paths.board;
  static const profile = _Paths.profile;
  static const platform = _Paths.platform;
  static const bookmark = _Paths.bookmark;
}

abstract class _Paths {
  _Paths._();
  static const base = '/';
  static const board = '/board';
  static const profile = '/profile';
  static const login = '/login';
  static const platform = '/subscribe';
  static const bookmark = '/bookmark';
}
