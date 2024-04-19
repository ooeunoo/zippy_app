import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:get/get.dart';

class CocomuBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);
  }
}
