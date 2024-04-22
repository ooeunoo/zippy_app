import 'package:zippy/presentation/pages/base/base.dart';
import 'package:zippy/presentation/pages/base/bindings/base_binding.dart';
import 'package:zippy/presentation/pages/login/bindings/login_binding.dart';
import 'package:zippy/presentation/pages/login/login.dart';
import 'package:get/route_manager.dart';
import 'package:zippy/presentation/pages/subscribe_channel/bindings/subscribe_channel_binding.dart';
import 'package:zippy/presentation/pages/subscribe_channel/subscribe_channel.dart';

class AppPages {
  static const initial = _Paths.login;

  static final routes = [
    GetPage(
        name: _Paths.login, page: () => const Login(), binding: LoginBinding()),
    GetPage(
        name: _Paths.base, page: () => const Base(), binding: BaseBinding()),
    GetPage(
        name: _Paths.subscribeChannel,
        page: () => const SubscribeChannel(),
        transition: Transition.rightToLeft,
        binding: SubscribeChannelBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const base = _Paths.base;
  static const subscribeChannel = _Paths.subscribeChannel;
}

abstract class _Paths {
  _Paths._();
  static const login = '/login';
  static const base = '/';
  static const subscribeChannel = '/user/subscribe';
}
