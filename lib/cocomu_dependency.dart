import 'package:cocomu/data/providers/dcinside/dcinside.dart';
import 'package:cocomu/data/repositories/community_repository_impl.dart';
import 'package:get/get.dart';

class CocomuBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<DcinsideAPI>(DcinsideAPI());

    Get.lazyPut(() => CommunityRepositoryIml(Get.find()));
  }
}
