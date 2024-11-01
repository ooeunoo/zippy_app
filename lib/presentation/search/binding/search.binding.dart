import 'package:get/get.dart';
import 'package:zippy/presentation/search/controller/search.controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}
