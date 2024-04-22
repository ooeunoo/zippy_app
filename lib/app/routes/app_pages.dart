import 'package:cocomu/presentation/pages/base/base.dart';
import 'package:cocomu/presentation/pages/base/bindings/base_binding.dart';
import 'package:cocomu/presentation/pages/login/bindings/login_binding.dart';
import 'package:cocomu/presentation/pages/login/login.dart';
import 'package:get/route_manager.dart';

class AppPages {
  static const initial = _Paths.login;

  static final routes = [
    GetPage(
        name: _Paths.login, page: () => const Login(), binding: LoginBinding()),
    GetPage(
        name: _Paths.base, page: () => const Base(), binding: BaseBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const base = _Paths.base;
}

abstract class _Paths {
  _Paths._();
  static const login = '/login';
  static const base = '/';
}
