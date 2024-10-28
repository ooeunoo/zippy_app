import 'package:zippy/app/services/admob_service.dart';
import 'package:zippy/data/providers/supabase.provider.dart';

import 'package:get/get.dart';

class ZippyBindings implements Bindings {
  @override
  void dependencies() {
    SupabaseProvider.init();

    Get.put<SupabaseProvider>(SupabaseProvider(), permanent: true);
    Get.put<AdmobService>(AdmobService(), permanent: true);
  }
}
