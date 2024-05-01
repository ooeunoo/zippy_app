import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/presentation/pages/base/base.dart';
import 'package:zippy/presentation/pages/base/bindings/base_binding.dart';
import 'package:zippy/presentation/pages/bookmark/bindings/bookmark_binding.dart';
import 'package:zippy/presentation/pages/bookmark/bookmark_view.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/pages/channel/bindings/channel_binding.dart';
import 'package:zippy/presentation/pages/channel/channel_view.dart';

class AppPages {
  static const initial = _Paths.base;

  static final routes = [
    GetPage(
        name: _Paths.base, page: () => const Base(), binding: BaseBinding()),
    GetPage(
        name: _Paths.channel,
        page: () => const ChannelView(),
        transition: Transition.rightToLeft,
        binding: ChannelBinding()),
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
  static const channel = _Paths.channel;
  static const bookmark = _Paths.bookmark;
}

abstract class _Paths {
  _Paths._();
  static const base = '/';
  static const channel = '/user/subscribe';
  static const bookmark = '/user/bookmark';
}
