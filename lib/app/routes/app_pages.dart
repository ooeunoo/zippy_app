import 'package:cocomu/presentation/pages/board/bindings/board_binding.dart';
import 'package:get/route_manager.dart';
import 'package:cocomu/presentation/pages/board/board.dart';

class AppPages {
  static const initial = _Paths.board;

  static final routes = [
    GetPage(
        name: _Paths.board, page: () => const Board(), binding: BoardBinding()),
  ];
}

abstract class Routes {
  Routes._();
  static const board = _Paths.board;
}

abstract class _Paths {
  _Paths._();
  static const board = '/';
}
