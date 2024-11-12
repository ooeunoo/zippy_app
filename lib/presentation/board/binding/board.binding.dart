import 'package:get/get.dart';
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_platforms.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/controller/board.controller.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoardController>(() => BoardController());
  }
}
