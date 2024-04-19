import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:cocomu/data/sources/implementations/category_data_source_impl.dart';
import 'package:cocomu/data/sources/implementations/community_data_source_impl.dart';
import 'package:cocomu/data/sources/implementations/item_data_source_impl.dart';
import 'package:cocomu/data/sources/interfaces/category_data_source.dart';
import 'package:cocomu/data/sources/interfaces/community_data_source.dart';
import 'package:cocomu/data/sources/interfaces/item_data_source.dart';
import 'package:cocomu/domain/repositories/implementations/category_repository.dart';
import 'package:cocomu/domain/repositories/implementations/community_repository.dart';
import 'package:cocomu/domain/repositories/implementations/item_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/category_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/community_repository.dart';
import 'package:cocomu/domain/repositories/interfaces/item_repository.dart';
import 'package:get/get.dart';

class CocomuBindings implements Bindings {
  @override
  void dependencies() {
    SupabaseProvider.init();
    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);

    Get.put<CommunityDatasource>(CommunityDatasourceIml(), permanent: true);
    Get.put<CommunityRepository>(CommunityRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<CategoryDatasource>(CategoryDatasourceIml(), permanent: true);
    Get.put<CategoryRepository>(CategoryRepositoryImpl(Get.find()),
        permanent: true);

    Get.put<ItemDatasource>(ItemDatasourceImpl(), permanent: true);
    Get.put<ItemRepository>(ItemRepositoryImpl(Get.find()), permanent: true);
  }
}
