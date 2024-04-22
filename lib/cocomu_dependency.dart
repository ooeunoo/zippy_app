import 'package:cocomu/app/services/admob_service.dart';
import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:cocomu/data/sources/implementations/category_data_source_impl.dart';
import 'package:cocomu/data/sources/implementations/community_data_source_impl.dart';
import 'package:cocomu/data/sources/implementations/item_data_source_impl.dart';
import 'package:cocomu/data/sources/implementations/user_data_source_impl.dart';
import 'package:cocomu/data/sources/interfaces/category_data_source.dart';
import 'package:cocomu/data/sources/interfaces/community_data_source.dart';
import 'package:cocomu/data/sources/interfaces/item_data_source.dart';
import 'package:cocomu/data/sources/interfaces/user_data_source.dart';
import 'package:cocomu/domain/repositories/implementations/category_repository_impl.dart';
import 'package:cocomu/domain/repositories/implementations/community_repository_impl.dart';
import 'package:cocomu/domain/repositories/implementations/item_repository_impl.dart';
import 'package:cocomu/domain/repositories/implementations/user_repository_impl.dart';
import 'package:cocomu/domain/repositories/interfaces/category_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/community_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/item_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/user_repository.dart';
import 'package:cocomu/domain/usecases/get_user.dart';
import 'package:cocomu/domain/usecases/login_with_kakao.dart';
import 'package:cocomu/domain/usecases/logout.dart';
import 'package:cocomu/domain/usecases/subscirbe_user.dart';
import 'package:cocomu/presentation/controllers/auth/auth_controller.dart';
import 'package:cocomu/presentation/controllers/base/base_controller.dart';
import 'package:get/get.dart';

class CocomuBindings implements Bindings {
  @override
  void dependencies() {
    SupabaseProvider.init();
    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);
    Get.put<AdmobService>(AdmobService(), permanent: true);

    Get.put<BaseController>(BaseController(), permanent: true);

    Get.put<CommunityDatasource>(CommunityDatasourceIml(), permanent: true);
    Get.put<CommunityRepository>(CommunityRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<CategoryDatasource>(CategoryDatasourceIml(), permanent: true);
    Get.put<CategoryRepository>(CategoryRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<ItemDatasource>(ItemDatasourceImpl(), permanent: true);
    Get.put<ItemRepository>(ItemRepositoryImpl(Get.find()), permanent: true);

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
