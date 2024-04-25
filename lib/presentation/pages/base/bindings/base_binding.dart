import 'package:zippy/data/sources/implementations/bookmark_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/category_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/channel_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/item_data_source_impl.dart';
import 'package:zippy/data/sources/implementations/user_channel_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/data/sources/interfaces/channel_data_source.dart';
import 'package:zippy/data/sources/interfaces/item_data_source.dart';
import 'package:zippy/data/sources/interfaces/user_channel_data_source.dart';
import 'package:zippy/domain/repositories/implementations/bookmark_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/category_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/channel;_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/item_repository_impl.dart';
import 'package:zippy/domain/repositories/implementations/user_channel_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:zippy/domain/repositories/interfaces/category_repository.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';
import 'package:zippy/domain/usecases/create_bookmark.dart';
import 'package:zippy/domain/usecases/delete_bookmark.dart';
import 'package:zippy/domain/usecases/get_bookmarks_by_user_id.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_channels.dart';
import 'package:zippy/domain/usecases/get_user_channel_by_user_id.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.dart';
import 'package:zippy/domain/usecases/subscirbe_user_channel.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class BaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(BaseController(), permanent: true);
  }
}
