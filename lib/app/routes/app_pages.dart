import 'package:zippy/presentation/pages/base/base.dart';
import 'package:zippy/presentation/pages/base/bindings/base.binding.dart';
import 'package:zippy/presentation/pages/bookmark/bindings/bookmark.binding.dart';
import 'package:zippy/presentation/pages/bookmark/bookmark_view.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/pages/platform/bindings/platform_binding.dart';
import 'package:zippy/presentation/pages/platform/platform_view.dart';

class AppPages {
  static const initial = _Paths.base;

  static final routes = [
    GetPage(
        name: _Paths.base, page: () => const Base(), binding: BaseBinding()),
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
  static const platform = _Paths.platform;
  static const bookmark = _Paths.bookmark;
}

abstract class _Paths {
  _Paths._();
  static const base = '/';
  static const platform = '/user/subscribe';
  static const bookmark = '/user/bookmark';
}
