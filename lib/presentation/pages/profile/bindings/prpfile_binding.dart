import 'package:zippy/data/sources/implementations/user_data_source_impl.dart';
import 'package:zippy/data/sources/interfaces/user_data_source.dart';
import 'package:zippy/domain/repositories/implementations/user_repository_impl.dart';
import 'package:zippy/domain/repositories/interfaces/user_repository.dart';
import 'package:zippy/domain/usecases/get_categories.dart';
import 'package:zippy/domain/usecases/get_communities.dart';
import 'package:zippy/domain/usecases/get_user.dart';
import 'package:zippy/domain/usecases/login_with_kakao.dart';
import 'package:zippy/domain/usecases/logout.dart';
import 'package:zippy/domain/usecases/subscirbe_items.dart';
import 'package:zippy/domain/usecases/subscirbe_user.dart';
import 'package:zippy/presentation/controllers/auth/auth_controller.dart';
import 'package:zippy/presentation/controllers/base/base_controller.dart';
import 'package:zippy/presentation/controllers/board/board_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<UserDatasource>(UserDatasourceIml(), permanent: true);
    Get.put<UserRepository>(UserRepositoryImpl(Get.find()), permanent: true);

    Get.put<LoginWithKakao>(LoginWithKakao(Get.find()), permanent: true);
    Get.put<SubscribeUser>(SubscribeUser(Get.find()), permanent: true);
    Get.put<Logout>(Logout(Get.find()), permanent: true);
    Get.put<GetUser>(GetUser(Get.find()), permanent: true);

    Get.put<AuthController>(
        AuthController(Get.find(), Get.find(), Get.find(), Get.find()),
        permanent: true);
  }
}
