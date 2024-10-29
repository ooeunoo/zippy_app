import 'package:zippy/presentation/pages/base/base.view.dart';
import 'package:zippy/presentation/pages/base/bindings/base.binding.dart';
import 'package:zippy/presentation/pages/bookmark/bindings/bookmark.binding.dart';
import 'package:zippy/presentation/pages/bookmark/bookmark.view.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/pages/login/bindings/login.binding.dart';
import 'package:zippy/presentation/pages/login/login.view.dart';
import 'package:zippy/presentation/pages/platform/bindings/platform.binding.dart';
import 'package:zippy/presentation/pages/platform/platform.view.dart';

class AppPages {
  static const initial = _Paths.login;

  static final routes = [
    GetPage(
        name: _Paths.base,
        page: () => const BaseView(),
        binding: BaseBinding()),
    GetPage(
        name: _Paths.login,
        page: () => const LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: _Paths.platform,
        page: () => const PlatformView(),
        transition: Transition.rightToLeft,
        binding: PlatformBinding()),
    GetPage(
        name: _Paths.bookmark,
        page: () => const BookmarkView(),
        transition: Transition.rightToLeft,
        binding: BookmarkBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const base = _Paths.base;
  static const login = _Paths.login;
  static const platform = _Paths.platform;
  static const bookmark = _Paths.bookmark;
}

abstract class _Paths {
  _Paths._();
  static const base = '/';
  static const login = '/login';
  static const platform = '/subscribe';
  static const bookmark = '/bookmark';
}
